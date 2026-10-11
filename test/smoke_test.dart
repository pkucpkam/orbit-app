import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/app.dart';
import 'package:quy_dao/core/strings/app_strings.dart';

void main() {
  testWidgets(
    'Smoke test: Khởi chạy App với ProviderScope và hiển thị tab Tổng quan',
    (WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pumpAndSettle();

      // Kiểm tra có tab Tổng quan trong thanh điều hướng và màn hình
      expect(find.text(AppStrings.tabOverview), findsAtLeastNWidgets(1));
      expect(find.text(AppStrings.tabTransactions), findsOneWidget);
      expect(find.text(AppStrings.tabBudgets), findsOneWidget);
      expect(find.text(AppStrings.tabSavings), findsOneWidget);
    },
  );
}
