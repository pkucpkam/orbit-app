/// Repository hồ sơ người dùng (users/{uid}) và khởi tạo dữ liệu lần đầu.
///
/// Khi người dùng tạo tài khoản lần đầu:
/// 1. Ghi doc users/{uid} với thông tin hồ sơ
/// 2. Seed danh mục mặc định
/// 3. Tạo ví đầu tiên (người dùng nhập trong onboarding)
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';
import 'package:quy_dao/data/repositories/category_repository.dart';

// ---------------------------------------------------------------------------
// Model hồ sơ người dùng (không cần Freezed vì không cần copyWith phức tạp)
// ---------------------------------------------------------------------------

class UserProfile {
  const UserProfile({
    required this.uid,
    required this.displayName,
    this.currency = 'VND',
    this.monthStartDay = 1,
    this.reminderTime = '21:00',
    this.schemaVersion = 1,
    this.createdAt,
  });

  final String uid;
  final String displayName;
  final String currency;
  final int monthStartDay;
  final String reminderTime;
  final int schemaVersion;
  final DateTime? createdAt;

  Map<String, dynamic> toFirestore() => {
    'displayName': displayName,
    'currency': currency,
    'monthStartDay': monthStartDay,
    'reminderTime': reminderTime,
    'schemaVersion': schemaVersion,
    'createdAt': createdAt != null
        ? Timestamp.fromDate(createdAt!)
        : FieldValue.serverTimestamp(),
  };

  factory UserProfile.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    DateTime? createdAt;
    if (data['createdAt'] is Timestamp) {
      createdAt = (data['createdAt'] as Timestamp).toDate();
    }
    return UserProfile(
      uid: doc.id,
      displayName: data['displayName'] as String? ?? '',
      currency: data['currency'] as String? ?? 'VND',
      monthStartDay: data['monthStartDay'] as int? ?? 1,
      reminderTime: data['reminderTime'] as String? ?? '21:00',
      schemaVersion: data['schemaVersion'] as int? ?? 1,
      createdAt: createdAt,
    );
  }
}

// ---------------------------------------------------------------------------
// Repository Interface
// ---------------------------------------------------------------------------

abstract interface class UserRepository {
  /// Stream hồ sơ người dùng hiện tại.
  Stream<UserProfile?> watchProfile(String uid);

  /// Cập nhật hồ sơ (displayName, monthStartDay, reminderTime).
  Future<void> updateProfile(String uid, UserProfile profile);

  /// Khởi tạo dữ liệu lần đầu sau khi đăng ký:
  /// - Tạo doc users/{uid}
  /// - Seed danh mục mặc định
  /// - Tạo ví đầu tiên
  Future<void> initializeNewUser({
    required User firebaseUser,
    required Wallet firstWallet,
    required int monthStartDay,
  });

  /// Kiểm tra xem người dùng đã có dữ liệu chưa (để quyết định bỏ qua onboarding).
  Future<bool> isUserInitialized(String uid);
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class FirestoreUserRepository implements UserRepository {
  FirestoreUserRepository({
    required FirebaseFirestore firestore,
    required FirestoreCategoryRepository categoryRepo,
  }) : _firestore = firestore,
       _categoryRepo = categoryRepo;

  final FirebaseFirestore _firestore;
  final FirestoreCategoryRepository _categoryRepo;

  DocumentReference<Map<String, dynamic>> _userDoc(String uid) =>
      _firestore.collection(FirestorePaths.users).doc(uid);

  @override
  Stream<UserProfile?> watchProfile(String uid) => _userDoc(
    uid,
  ).snapshots().map((doc) => doc.exists ? UserProfile.fromDoc(doc) : null);

  @override
  Future<void> updateProfile(String uid, UserProfile profile) =>
      _userDoc(uid).update({
        'displayName': profile.displayName,
        'monthStartDay': profile.monthStartDay,
        'reminderTime': profile.reminderTime,
      });

  @override
  Future<void> initializeNewUser({
    required User firebaseUser,
    required Wallet firstWallet,
    required int monthStartDay,
  }) async {
    final uid = firebaseUser.uid;

    // 1. Tạo hồ sơ người dùng
    final profile = UserProfile(
      uid: uid,
      displayName:
          firebaseUser.displayName ?? firebaseUser.email ?? 'Người dùng',
      monthStartDay: monthStartDay,
    );
    await _userDoc(uid).set(profile.toFirestore(), SetOptions(merge: true));

    // 2. Seed danh mục mặc định
    await _categoryRepo.seedDefaultCategories(uid);

    // 3. Tạo ví đầu tiên
    final walletRef = _firestore
        .collection(FirestorePaths.walletsCollection(uid))
        .doc(firstWallet.id.isEmpty ? null : firstWallet.id);

    await walletRef.set({
      'name': firstWallet.name,
      'type': firstWallet.type,
      'balance': firstWallet.balance,
      'initialBalance': firstWallet.balance,
      'archived': false,
      'order': 0,
    });
  }

  @override
  Future<bool> isUserInitialized(String uid) async {
    final doc = await _userDoc(uid).get();
    return doc.exists;
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => FirestoreUserRepository(
    firestore: ref.watch(firestoreProvider),
    categoryRepo: ref.watch(categoryRepositoryProvider),
  ),
  name: 'userRepositoryProvider',
);

/// Stream hồ sơ người dùng hiện tại.
final userProfileStreamProvider = StreamProvider.autoDispose<UserProfile?>((
  ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watchProfile(uid);
}, name: 'userProfileStreamProvider');

/// Tự động khởi tạo dữ liệu cho user nếu chưa có trong Firestore.
final ensureUserInitializedProvider = FutureProvider.autoDispose<void>((
  ref,
) async {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return;
  final authUser = ref.watch(firebaseAuthProvider)?.currentUser;
  if (authUser == null) return;

  final userRepo = ref.watch(userRepositoryProvider);
  final isInit = await userRepo.isUserInitialized(uid);
  if (!isInit) {
    await userRepo.initializeNewUser(
      firebaseUser: authUser,
      firstWallet: const Wallet(
        id: '',
        name: 'Tiền mặt',
        type: 'cash',
        balance: 0,
      ),
      monthStartDay: 1,
    );
  }
}, name: 'ensureUserInitializedProvider');
