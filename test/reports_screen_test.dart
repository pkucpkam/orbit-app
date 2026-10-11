import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/data/models/category.dart';
import 'package:quy_dao/data/models/transaction.dart';
import 'package:quy_dao/data/providers/app_state_providers.dart';
import 'package:quy_dao/features/reports/presentation/reports_screen.dart';

void main() {
  testWidgets('ReportsScreen hiển thị trạng thái rỗng khi chưa có chi tiêu', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: ReportsScreen())),
    );
    await tester.pumpAndSettle();

    // Tiêu đề
    expect(find.text(AppStrings.reports), findsOneWidget);
    // 3 chip thời gian
    expect(find.text(AppStrings.periodMonth), findsOneWidget);
    expect(find.text(AppStrings.periodQuarter), findsOneWidget);
    expect(find.text(AppStrings.periodYear), findsOneWidget);
    // Trạng thái trống
    expect(find.text(AppStrings.emptyReport), findsOneWidget);
  });

  testWidgets(
    'ReportsScreen hiển thị biểu đồ Donut và danh sách chi tiêu khi có dữ liệu',
    (tester) async {
      final mockCategories = [
        const Category(
          id: 'cat_food',
          name: 'Ăn uống',
          icon: 'restaurant',
          type: 'expense',
          colorToken: 'orange',
        ),
        const Category(
          id: 'cat_coffee',
          name: 'Cà phê',
          icon: 'local_cafe',
          type: 'expense',
          colorToken: 'orange',
        ),
      ];

      final mockTxs = [
        Transaction(
          id: 'tx_1',
          type: 'expense',
          amount: 150000,
          categoryId: 'cat_food',
          walletId: 'w1',
          date: DateTime.now(),
          monthKey: '2026-10',
          note: 'Ăn trưa cơm tấm',
        ),
        Transaction(
          id: 'tx_2',
          type: 'expense',
          amount: 45000,
          categoryId: 'cat_coffee',
          walletId: 'w1',
          date: DateTime.now(),
          monthKey: '2026-10',
          note: 'Cà phê sáng',
        ),
      ];

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoriesProvider.overrideWithValue(mockCategories),
            transactionsProvider.overrideWithValue(mockTxs),
          ],
          child: const MaterialApp(home: ReportsScreen()),
        ),
      );
      await tester.pumpAndSettle();

      // Kiểm tra các thành phần của Báo cáo
      expect(find.text(AppStrings.reportOverview), findsOneWidget);
      expect(find.text(AppStrings.reportIncomeVsExpense), findsOneWidget);
      expect(find.text(AppStrings.reportCategories), findsOneWidget);
      expect(find.text(AppStrings.reportTopExpenses), findsOneWidget);

      // Kiểm tra tên các danh mục xuất hiện
      expect(find.text('Ăn uống'), findsWidgets);
      expect(find.text('Cà phê'), findsWidgets);
      expect(find.text('Ăn trưa cơm tấm'), findsOneWidget);
    },
  );
}
