/// Repository xác thực người dùng.
///
/// Bao gồm:
/// - Đăng nhập Google
/// - Đăng nhập Apple (iOS)
/// - Đăng nhập email + mật khẩu
/// - Đăng xuất
/// - Xóa tài khoản
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'package:quy_dao/data/repositories/app_providers.dart';

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

abstract interface class AuthRepository {
  /// Đăng nhập bằng tài khoản Google.
  Future<UserCredential> signInWithGoogle();

  /// Đăng nhập bằng Apple ID (chỉ iOS).
  Future<UserCredential> signInWithApple();

  /// Đăng nhập bằng email và mật khẩu.
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  });

  /// Tạo tài khoản mới bằng email và mật khẩu.
  Future<UserCredential> createWithEmail({
    required String email,
    required String password,
  });

  /// Đăng nhập ẩn danh (Khách) để trải nghiệm nhanh.
  Future<UserCredential> signInAnonymously();

  /// Đặt lại mật khẩu qua email.
  Future<void> sendPasswordResetEmail(String email);

  /// Đăng xuất khỏi tất cả provider.
  Future<void> signOut();

  /// Xóa tài khoản và toàn bộ dữ liệu Firestore của người dùng.
  /// Yêu cầu đăng nhập lại gần đây (re-auth) trước khi gọi.
  Future<void> deleteAccount();
}

// ---------------------------------------------------------------------------
// Implementation Firestore
// ---------------------------------------------------------------------------

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    this.serverClientId,
  }) : _auth = auth,
       _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final String? serverClientId;

  @override
  Future<UserCredential> signInWithGoogle() async {
    await GoogleSignIn.instance.initialize(serverClientId: serverClientId);
    final googleUser = await GoogleSignIn.instance.authenticate();
    final googleAuth = googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );
    return _auth.signInWithCredential(credential);
  }

  @override
  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    return _auth.signInWithCredential(oauthCredential);
  }

  @override
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) => _auth.signInWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> createWithEmail({
    required String email,
    required String password,
  }) => _auth.createUserWithEmailAndPassword(email: email, password: password);

  @override
  Future<UserCredential> signInAnonymously() => _auth.signInAnonymously();

  @override
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _auth.signOut();
  }

  @override
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Xóa toàn bộ sub-collection của user theo từng đợt WriteBatch.
    // Thứ tự: transactions → wallets → categories → budgets
    //       → monthSummaries → goals → recurring → stats
    // Sau đó xóa doc users/{uid} và tài khoản Auth.
    final uid = user.uid;
    final userRef = _firestore.collection('users').doc(uid);

    final collections = [
      'transactions',
      'wallets',
      'categories',
      'budgets',
      'monthSummaries',
      'goals',
      'recurring',
      'stats',
    ];

    for (final col in collections) {
      final snapshot = await userRef.collection(col).get();
      if (snapshot.docs.isEmpty) continue;
      // Chia nhỏ thành batch 490 doc (giới hạn an toàn < 500)
      for (var i = 0; i < snapshot.docs.length; i += 490) {
        final batch = _firestore.batch();
        final chunk = snapshot.docs.sublist(
          i,
          i + 490 > snapshot.docs.length ? snapshot.docs.length : i + 490,
        );
        for (final doc in chunk) {
          batch.delete(doc.reference);
        }
        await batch.commit();
      }
    }

    // Xóa doc người dùng
    await userRef.delete();
    // Xóa tài khoản Firebase Auth (cần re-auth gần đây)
    await user.delete();
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

/// Provider cấu hình OAuth Web Client ID cho Google Sign-In (serverClientId).
///
/// Tránh hardcode secret/client ID trong mã nguồn; hỗ trợ cấu hình qua cờ:
/// `--dart-define=GOOGLE_SERVER_CLIENT_ID=...`
final googleServerClientIdProvider = Provider<String?>((ref) {
  const clientId = String.fromEnvironment('GOOGLE_SERVER_CLIENT_ID');
  return clientId.isNotEmpty ? clientId : null;
});

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => FirebaseAuthRepository(
    auth: ref.watch(firebaseAuthProvider) ?? FirebaseAuth.instance,
    firestore: ref.watch(firestoreProvider),
    serverClientId: ref.watch(googleServerClientIdProvider),
  ),
  name: 'authRepositoryProvider',
);
