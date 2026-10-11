/// Repository quản lý danh mục (Category).
library;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/repositories/app_providers.dart';

// ---------------------------------------------------------------------------
// Interface
// ---------------------------------------------------------------------------

abstract interface class CategoryRepository {
  /// Stream danh mục chưa bị ẩn, sắp xếp theo order.
  Stream<List<Category>> watchCategories(String uid, {String? type});

  /// Stream tất cả danh mục (kể cả archived), dùng cho Cài đặt.
  Stream<List<Category>> watchAllCategories(String uid);

  /// Tạo hoặc cập nhật danh mục.
  Future<String> saveCategory(String uid, Category category);

  /// Ẩn danh mục (archived = true). Danh mục có giao dịch chỉ được ẩn.
  Future<void> archiveCategory(String uid, String categoryId);

  /// Cập nhật thứ tự sắp xếp hàng loạt (drag-and-drop trong Cài đặt).
  Future<void> reorderCategories(
    String uid,
    List<({String id, int order})> updates,
  );

  /// Lấy tất cả danh mục mặc định (seed data khi tạo tài khoản mới).
  static List<Category> defaultCategories() => _defaultCategories;
}

// ---------------------------------------------------------------------------
// Default seed categories
// ---------------------------------------------------------------------------

final List<Category> _defaultCategories = const [
  // Chi tiêu
  Category(
    id: 'cat_food',
    name: 'Ăn uống',
    type: 'expense',
    icon: '🍜',
    colorToken: 'orange',
    order: 0,
  ),
  Category(
    id: 'cat_transport',
    name: 'Di chuyển',
    type: 'expense',
    icon: '🚗',
    colorToken: 'blue',
    order: 1,
  ),
  Category(
    id: 'cat_shopping',
    name: 'Mua sắm',
    type: 'expense',
    icon: '🛍️',
    colorToken: 'pink',
    order: 2,
  ),
  Category(
    id: 'cat_entertainment',
    name: 'Giải trí',
    type: 'expense',
    icon: '🎮',
    colorToken: 'purple',
    order: 3,
  ),
  Category(
    id: 'cat_health',
    name: 'Sức khỏe',
    type: 'expense',
    icon: '💊',
    colorToken: 'green',
    order: 4,
  ),
  Category(
    id: 'cat_education',
    name: 'Học tập',
    type: 'expense',
    icon: '📚',
    colorToken: 'teal',
    order: 5,
  ),
  Category(
    id: 'cat_bills',
    name: 'Hóa đơn',
    type: 'expense',
    icon: '💡',
    colorToken: 'yellow',
    order: 6,
  ),
  Category(
    id: 'cat_other_expense',
    name: 'Khác',
    type: 'expense',
    icon: '💸',
    colorToken: 'gray',
    order: 7,
  ),
  // Thu nhập
  Category(
    id: 'cat_salary',
    name: 'Lương',
    type: 'income',
    icon: '💰',
    colorToken: 'green',
    order: 0,
  ),
  Category(
    id: 'cat_bonus',
    name: 'Thưởng',
    type: 'income',
    icon: '🎁',
    colorToken: 'orange',
    order: 1,
  ),
  Category(
    id: 'cat_freelance',
    name: 'Freelance',
    type: 'income',
    icon: '💻',
    colorToken: 'blue',
    order: 2,
  ),
  Category(
    id: 'cat_other_income',
    name: 'Thu nhập khác',
    type: 'income',
    icon: '💵',
    colorToken: 'teal',
    order: 3,
  ),
];

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

extension _CategoryJson on Category {
  Map<String, dynamic> toFirestore() => {
    'name': name,
    'type': type,
    'icon': icon,
    'colorToken': colorToken,
    'order': order,
    'archived': archived,
  };
}

Category _fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Category.fromJson({...data, 'id': doc.id});
}

// ---------------------------------------------------------------------------
// Implementation
// ---------------------------------------------------------------------------

class FirestoreCategoryRepository implements CategoryRepository {
  FirestoreCategoryRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _col(String uid) =>
      _firestore.collection(FirestorePaths.categoriesCollection(uid));

  @override
  Stream<List<Category>> watchCategories(String uid, {String? type}) {
    Query<Map<String, dynamic>> query = _col(
      uid,
    ).where('archived', isEqualTo: false);
    if (type != null) query = query.where('type', isEqualTo: type);
    return query
        .orderBy('order')
        .snapshots()
        .map((s) => s.docs.map(_fromDoc).toList());
  }

  @override
  Stream<List<Category>> watchAllCategories(String uid) => _col(uid)
      .orderBy('type')
      .orderBy('order')
      .snapshots()
      .map((s) => s.docs.map(_fromDoc).toList());

  @override
  Future<String> saveCategory(String uid, Category category) async {
    final ref = category.id.isEmpty
        ? _col(uid).doc()
        : _col(uid).doc(category.id);
    await ref.set(category.toFirestore(), SetOptions(merge: true));
    return ref.id;
  }

  @override
  Future<void> archiveCategory(String uid, String categoryId) =>
      _col(uid).doc(categoryId).update({'archived': true});

  @override
  Future<void> reorderCategories(
    String uid,
    List<({String id, int order})> updates,
  ) async {
    final batch = _firestore.batch();
    for (final u in updates) {
      batch.update(_col(uid).doc(u.id), {'order': u.order});
    }
    await batch.commit();
  }

  /// Ghi toàn bộ danh mục mặc định vào Firestore (chỉ dùng khi tạo tài khoản mới).
  Future<void> seedDefaultCategories(String uid) async {
    final batch = _firestore.batch();
    for (final cat in _defaultCategories) {
      batch.set(
        _col(uid).doc(cat.id),
        cat.toFirestore(),
        SetOptions(merge: true),
      );
    }
    await batch.commit();
  }
}

// ---------------------------------------------------------------------------
// Riverpod Providers
// ---------------------------------------------------------------------------

final categoryRepositoryProvider = Provider<FirestoreCategoryRepository>(
  (ref) => FirestoreCategoryRepository(ref.watch(firestoreProvider)),
  name: 'categoryRepositoryProvider',
);

/// Stream danh mục chi tiêu active.
final expenseCategoriesProvider = StreamProvider.autoDispose<List<Category>>((
  ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref
      .watch(categoryRepositoryProvider)
      .watchCategories(uid, type: 'expense');
}, name: 'expenseCategoriesProvider');

/// Stream danh mục thu nhập active.
final incomeCategoriesProvider = StreamProvider.autoDispose<List<Category>>((
  ref,
) {
  final uid = ref.watch(currentUidProvider);
  if (uid == null) return Stream.value(const []);
  return ref
      .watch(categoryRepositoryProvider)
      .watchCategories(uid, type: 'income');
}, name: 'incomeCategoriesProvider');
