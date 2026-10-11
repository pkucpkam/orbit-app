import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/data/firestore_paths.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/repositories/transaction_repository.dart';

void main() {
  group('FirestoreTransactionRepository Tests (Atomic WriteBatch)', () {
    late FakeFirebaseFirestore fakeFirestore;
    late FirestoreTransactionRepository repository;
    const uid = 'test_user_123';
    const monthKey = '2026-10';
    const walletId = 'wallet_cash';
    const toWalletId = 'wallet_bank';
    const goalId = 'goal_laptop';

    setUp(() async {
      fakeFirestore = FakeFirebaseFirestore();
      repository = FirestoreTransactionRepository(fakeFirestore);

      // Seed initial wallet balance: 1,000,000 VND
      await fakeFirestore
          .collection(FirestorePaths.walletsCollection(uid))
          .doc(walletId)
          .set({
            'name': 'Tiền mặt',
            'type': 'cash',
            'balance': 1000000,
            'initialBalance': 1000000,
            'archived': false,
            'order': 0,
          });

      // Seed destination wallet: 500,000 VND
      await fakeFirestore
          .collection(FirestorePaths.walletsCollection(uid))
          .doc(toWalletId)
          .set({
            'name': 'Ngân hàng',
            'type': 'bank',
            'balance': 500000,
            'initialBalance': 500000,
            'archived': false,
            'order': 1,
          });

      // Seed goal: 0 / 20,000,000 VND
      await fakeFirestore
          .collection(FirestorePaths.goalsCollection(uid))
          .doc(goalId)
          .set({
            'name': 'Laptop mới',
            'targetAmount': 20000000,
            'savedAmount': 0,
            'startDate': '2026-10-01T00:00:00.000Z',
            'targetDate': '2026-12-31T00:00:00.000Z',
            'icon': '💻',
            'colorToken': 'signalOrange',
            'status': 'active',
            'milestonesReached': [],
          });
    });

    test(
      'TXN-1: Thêm khoản Chi (expense) cập nhật đồng thời ví và monthSummaries',
      () async {
        final tx = Transaction(
          id: '',
          type: 'expense',
          amount: 200000,
          categoryId: 'cat_food',
          walletId: walletId,
          date: DateTime(2026, 10, 11),
          monthKey: monthKey,
          note: 'Ăn trưa',
        );

        final txId = await repository.addTransaction(uid, tx);
        expect(txId, isNotEmpty);

        // Kiểm tra doc giao dịch đã được ghi
        final txDoc = await fakeFirestore
            .collection(FirestorePaths.transactionsCollection(uid))
            .doc(txId)
            .get();
        expect(txDoc.exists, isTrue);
        expect(txDoc.data()?['amount'], 200000);
        expect(txDoc.data()?['type'], 'expense');

        // Kiểm tra ví bị trừ 200,000 (1,000,000 - 200,000 = 800,000)
        final walletDoc = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(walletId)
            .get();
        expect(walletDoc.data()?['balance'], 800000);

        // Kiểm tra monthSummary được cộng totalExpense = 200,000
        final summaryDoc = await fakeFirestore
            .collection(FirestorePaths.monthSummariesCollection(uid))
            .doc(monthKey)
            .get();
        expect(summaryDoc.exists, isTrue);
        expect(summaryDoc.data()?['totalExpense'], 200000);
        expect(summaryDoc.data()?['byCategory']['cat_food'], 200000);
        expect(summaryDoc.data()?['loggedDays'], contains('2026-10-11'));
      },
    );

    test(
      'TXN-1: Thêm khoản Thu (income) cộng tiền vào ví và monthSummaries',
      () async {
        final tx = Transaction(
          id: '',
          type: 'income',
          amount: 5000000,
          categoryId: 'cat_salary',
          walletId: walletId,
          date: DateTime(2026, 10, 10),
          monthKey: monthKey,
          note: 'Lương thưởng',
        );

        await repository.addTransaction(uid, tx);

        // Kiểm tra ví được cộng (1,000,000 + 5,000,000 = 6,000,000)
        final walletDoc = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(walletId)
            .get();
        expect(walletDoc.data()?['balance'], 6000000);

        // Kiểm tra monthSummary
        final summaryDoc = await fakeFirestore
            .collection(FirestorePaths.monthSummariesCollection(uid))
            .doc(monthKey)
            .get();
        expect(summaryDoc.data()?['totalIncome'], 5000000);
        expect(summaryDoc.data()?['loggedDays'], contains('2026-10-10'));
      },
    );

    test(
      'TXN-3: Chuyển ví (transfer) trừ ví nguồn, cộng ví đích, không đổi tổng chi thu',
      () async {
        final tx = Transaction(
          id: '',
          type: 'transfer',
          amount: 300000,
          categoryId: '',
          walletId: walletId,
          toWalletId: toWalletId,
          date: DateTime(2026, 10, 11),
          monthKey: monthKey,
        );

        await repository.addTransaction(uid, tx);

        // Ví nguồn: 1,000,000 - 300,000 = 700,000
        final fromWallet = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(walletId)
            .get();
        expect(fromWallet.data()?['balance'], 700000);

        // Ví đích: 500,000 + 300,000 = 800,000
        final toWallet = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(toWalletId)
            .get();
        expect(toWallet.data()?['balance'], 800000);

        // Không tính vào thu hay chi
        final summaryDoc = await fakeFirestore
            .collection(FirestorePaths.monthSummariesCollection(uid))
            .doc(monthKey)
            .get();
        expect(summaryDoc.data()?['totalExpense'], isNull);
        expect(summaryDoc.data()?['totalIncome'], isNull);
      },
    );

    test(
      'SAV-2: Gửi tiết kiệm (saving) trừ ví, cộng goals.savedAmount và totalSaved',
      () async {
        final tx = Transaction(
          id: '',
          type: 'saving',
          amount: 1000000,
          categoryId: '',
          walletId: walletId,
          goalId: goalId,
          date: DateTime(2026, 10, 11),
          monthKey: monthKey,
        );

        await repository.addTransaction(uid, tx);

        // Ví bị trừ
        final wallet = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(walletId)
            .get();
        expect(wallet.data()?['balance'], 0);

        // Goal được cộng
        final goal = await fakeFirestore
            .collection(FirestorePaths.goalsCollection(uid))
            .doc(goalId)
            .get();
        expect(goal.data()?['savedAmount'], 1000000);

        // monthSummary tính vào totalSaved, không tính vào totalExpense
        final summary = await fakeFirestore
            .collection(FirestorePaths.monthSummariesCollection(uid))
            .doc(monthKey)
            .get();
        expect(summary.data()?['totalSaved'], 1000000);
        expect(summary.data()?['totalExpense'], isNull);
      },
    );

    test(
      'TXN-2: Xóa giao dịch hoàn trả đầy đủ số dư ví và tổng tháng',
      () async {
        final tx = Transaction(
          id: 'tx_delete_test',
          type: 'expense',
          amount: 150000,
          categoryId: 'cat_coffee',
          walletId: walletId,
          date: DateTime(2026, 10, 11),
          monthKey: monthKey,
        );

        // Thêm trước
        await repository.addTransaction(uid, tx);
        var wallet = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(walletId)
            .get();
        expect(wallet.data()?['balance'], 850000);

        // Xóa
        await repository.deleteTransaction(
          uid,
          tx.copyWith(id: 'tx_delete_test'),
        );

        // Ví được hoàn lại 150,000 -> 1,000,000
        wallet = await fakeFirestore
            .collection(FirestorePaths.walletsCollection(uid))
            .doc(walletId)
            .get();
        expect(wallet.data()?['balance'], 1000000);

        // Doc giao dịch đã bị xóa
        final txDoc = await fakeFirestore
            .collection(FirestorePaths.transactionsCollection(uid))
            .doc('tx_delete_test')
            .get();
        expect(txDoc.exists, isFalse);
      },
    );
  });
}
