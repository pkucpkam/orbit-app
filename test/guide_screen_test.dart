import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:quy_dao/features/guide/presentation/guide_screen.dart';

void main() {
  testWidgets('GuideScreen hiển thị giao diện hướng dẫn và tab điều hướng', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GuideScreen()));
    await tester.pumpAndSettle();

    // Kiểm tra tiêu đề và 2 tab
    expect(find.text(AppStrings.userGuide), findsOneWidget);
    expect(find.text(AppStrings.tutorialSteps), findsOneWidget);
    expect(find.text(AppStrings.featureHandbook), findsOneWidget);

    // Kiểm tra nội dung bước 1
    expect(find.text(AppStrings.guideStep1Badge), findsOneWidget);
    expect(find.text(AppStrings.guideStep1Title), findsOneWidget);
    expect(find.text(AppStrings.guideStep1Tip), findsOneWidget);
    expect(find.text(AppStrings.nextStep), findsOneWidget);
    expect(find.text(AppStrings.skipGuide), findsOneWidget);
  });

  testWidgets('Chuyển tiếp các bước trong Step Tutorial', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: GuideScreen()));
    await tester.pumpAndSettle();

    // Ban đầu ở bước 1, chưa có nút 'Quay lại'
    expect(find.text(AppStrings.previousStep), findsNothing);

    // Bấm 'Tiếp tục' chuyển sang bước 2
    await tester.tap(find.text(AppStrings.nextStep));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.guideStep2Badge), findsOneWidget);
    expect(find.text(AppStrings.guideStep2Title), findsOneWidget);
    // Đã xuất hiện nút 'Quay lại'
    expect(find.text(AppStrings.previousStep), findsOneWidget);

    // Bấm 'Quay lại' trở về bước 1
    await tester.tap(find.text(AppStrings.previousStep));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.guideStep1Badge), findsOneWidget);
    expect(find.text(AppStrings.previousStep), findsNothing);
  });

  testWidgets('Chuyển sang tab Cẩm nang tính năng và kiểm tra FAQ', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: GuideScreen()));
    await tester.pumpAndSettle();

    // Nhấn tab Cẩm nang tính năng
    await tester.tap(find.text(AppStrings.featureHandbook));
    await tester.pumpAndSettle();

    // Cuộn xuống để xem phần FAQ trong ListView
    await tester.scrollUntilVisible(
      find.text(AppStrings.faqSectionTitle),
      300.0,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    // Kiểm tra tiêu đề FAQ và câu hỏi
    expect(find.text(AppStrings.faqSectionTitle), findsOneWidget);
    expect(find.text(AppStrings.faq1Question), findsOneWidget);
    expect(find.text(AppStrings.faq2Question), findsOneWidget);

    // Nhấn vào FAQ để kiểm tra mở rộng
    await tester.tap(find.text(AppStrings.faq2Question));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.faq2Answer), findsOneWidget);
  });
}
