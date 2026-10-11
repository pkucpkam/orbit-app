import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/wallet.dart';
import 'package:quy_dao/data/repositories/category_repository.dart';
import 'package:quy_dao/data/repositories/user_repository.dart';

class MockUser extends Mock implements User {}

void main() {
  group('FirestoreUserRepository Tests (Onboarding & Initialization)', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreCategoryRepository categoryRepo;
    late FirestoreUserRepository userRepo;
    const uid = 'new_user_456';

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      categoryRepo = FirestoreCategoryRepository(fakeFirestore);
      userRepo = FirestoreUserRepository(
        firestore: fakeFirestore,
        categoryRepo: categoryRepo,
      );
    });

    test('isUserInitialized returns false before initialization', () async {
      final initialized = await userRepo.isUserInitialized(uid);
      expect(initialized, isFalse);
    });

    test(
      'initializeNewUser seeds profile, 12 categories, and first wallet',
      () async {
        final mockUser = MockUser();
        when(() => mockUser.uid).thenReturn(uid);
        when(() => mockUser.displayName).thenReturn('Trần Văn A');

        const firstWallet = Wallet(
          id: '',
          name: 'Tiền mặt',
          type: 'cash',
          balance: 500000,
          initialBalance: 500000,
        );

        await userRepo.initializeNewUser(
          firebaseUser: mockUser,
          firstWallet: firstWallet,
          monthStartDay: 1,
        );

        // 1. Kiểm tra doc user
        final userDoc = await fakeFirestore
            .doc(FirestorePaths.userDoc(uid))
            .get();
        expect(userDoc.exists, isTrue);
        expect(userDoc.data()?['displayName'], 'Trần Văn A');
        expect(userDoc.data()?['monthStartDay'], 1);
        expect(userDoc.data()?['currency'], 'VND');

        // 2. Kiểm tra 12 danh mục mặc định
        final categoriesSnap = await fakeFirestore
            .collection(FirestorePaths.categoriesCollection(uid))
            .get();
        expect(categoriesSnap.docs.length, 12);

        // 3. Kiểm tra ví đầu tiên
        final walletsSnap = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .get();
        expect(walletsSnap.docs.length, 1);
        final walletData = walletsSnap.docs.first.data();
        expect(walletData['name'], 'Tiền mặt');
        expect(walletData['balance'], 500000);

        // 4. isUserInitialized trả về true
        expect(await userRepo.isUserInitialized(uid), isTrue);
      },
    );
  });
}
