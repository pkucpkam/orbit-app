/// Các Riverpod provider gốc cho Firebase services.
///
/// Tất cả repository sẽ depend vào các provider này thay vì
/// gọi trực tiếp `FirebaseAuth.instance` hay `FirebaseFirestore.instance`
/// để dễ mock trong test.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider cho [FirebaseAuth] instance (`null` nếu chưa khởi tạo Firebase).
final firebaseAuthProvider = Provider<FirebaseAuth?>((ref) {
  try {
    return FirebaseAuth.instance;
  } catch (_) {
    return null;
  }
}, name: 'firebaseAuthProvider');

/// Provider cho [FirebaseFirestore] instance.
/// Đã bật offline persistence mặc định trên Android/iOS.
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  try {
    return FirebaseFirestore.instance;
  } catch (_) {
    return FirebaseFirestore.instance;
  }
}, name: 'firestoreProvider');

/// Stream theo dõi trạng thái đăng nhập hiện tại.
/// `null` = chưa đăng nhập.
final authStateChangesProvider = StreamProvider<User?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  if (auth == null) return Stream.value(null);
  return auth.authStateChanges();
}, name: 'authStateChangesProvider');

/// Provider trả về UID của user hiện tại (`null` nếu chưa đăng nhập).
final currentUidProvider = Provider<String?>((ref) {
  final user = ref.watch(authStateChangesProvider).asData?.value;
  if (user != null) return user.uid;
  final auth = ref.watch(firebaseAuthProvider);
  return auth?.currentUser?.uid;
}, name: 'currentUidProvider');
