/// Repository quản lý ví (Wallet).
///
/// Tuân thủ Quy tắc #3: Widget không gọi Firestore trực tiếp.
/// Tuân thủ Quy tắc #7: `balance` chỉ đổi bằng FieldValue.increment trong WriteBatch.
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

abstract interface class WalletRepository {
  /// Stream danh sách ví chưa bị ẩn (archived = false), sắp xếp theo order.
  Stream<List<Wallet>> watchWallets(String uid);

  /// Stream tất cả ví (kể cả archived), dùng cho màn Cài đặt.
  Stream<List<Wallet>> watchAllWallets(String uid);

  /// Tạo ví mới.
  Future<String> createWallet(String uid, Wallet wallet);

  /// Cập nhật thông tin ví (không cập nhật balance — balance chỉ đổi qua WriteBatch).
  Future<void> updateWallet(String uid, Wallet wallet);

  /// Ẩn ví (archived = true). Không cho phép xóa cứng.
  Future<void> archiveWallet(String uid, String walletId);

  /// Lấy ví theo ID một lần (không stream).
  Future<Wallet?> getWallet(String uid, String walletId);
}

// ---------------------------------------------------------------------------
// Helpers chuyển đổi Timestamp ↔ DateTime
// ---------------------------------------------------------------------------

extension _WalletJson on Wallet {
  Map<String, dynamic> toFirestore() => {
    'name': name,
    'type': type,
    'balance': balance,
    'initialBalance': initialBalance,
    'archived': archived,
    'order': order,
  };
}

Wallet _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Wallet.fromJson({...data, 'id': doc.id});
}

// ---------------------------------------------------------------------------
// Implementation Firestore
// ---------------------------------------------------------------------------

class FirestoreWalletRepository implements WalletRepository {
  FirestoreWalletRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.walletsCollection(uid));

  @override
  Stream<List<Wallet>> watchWallets(String uid) => _col(uid).snapshots().map(
    (s) =>
        s.docs.map(_fromDoc).where((w) => !w.archived).toList()
          ..sort((a, b) => a.order.compareTo(b.order)),
  );

  @override
  Stream<List<Wallet>> watchAllWallets(String uid) => _col(uid).snapshots().map(
    (s) =>
        s.docs.map(_fromDoc).toList()
          ..sort((a, b) => a.order.compareTo(b.order)),
  );

  @override
  Future<String> createWallet(String uid, Wallet wallet) async {
    final ref = wallet.id.isEmpty ? _col(uid).doc() : _col(uid).doc(wallet.id);
    await ref.set(wallet.toFirestore());
    return ref.id;
  }

  @override
  Future<void> updateWallet(String uid, Wallet wallet) =>
      _col(uid).doc(wallet.id).update({
        'name': wallet.name,
        'type': wallet.type,
        'archived': wallet.archived,
        'order': wallet.order,
        // balance KHÔNG được cập nhật ở đây; chỉ qua WriteBatch.
      });

  @override
  Future<void> archiveWallet(String uid, String walletId) =>
      _col(uid).doc(walletId).update({'archived': true});

  @override
  Future<Wallet?> getWallet(String uid, String walletId) async {
    final doc = await _col(uid).doc(walletId).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }
}

// ---------------------------------------------------------------------------
// Riverpod Provider
// ---------------------------------------------------------------------------

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => FirestoreWalletRepository(ref.watch(firestoreProvider)),
  name: 'walletRepositoryProvider',
);

/// Stream danh sách ví active của user hiện tại.
final walletsStreamProvider = StreamProvider.autoDispose<List<Wallet>>((ref) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(walletRepositoryProvider).watchWallets(uid);
}, name: 'walletsStreamProvider');
