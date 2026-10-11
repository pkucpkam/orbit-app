import 'dart:developer' as developer;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/core/strings/app_strings.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Interface trừu tượng cho dịch vụ thông báo cục bộ.
abstract interface class NotificationService {
  /// Khởi tạo plugin thông báo và cấu hình timezone.
  Future<void> initialize();

  /// Lên lịch nhắc nhở ghi chép hằng ngày lúc [hour]:[minute]. Mặc định 21:00.
  Future<void> scheduleDailyReminder({int hour = 21, int minute = 0});

  /// Hủy thông báo nhắc nhở hằng ngày.
  Future<void> cancelDailyReminder();

  /// Gửi thông báo cảnh báo ngân sách khi chạm mốc 80% hoặc 100%.
  Future<void> showBudgetAlert({
    required String categoryName,
    required int percent,
  });
}

/// Triển khai thực tế dựa trên [FlutterLocalNotificationsPlugin].
class LocalNotificationService implements NotificationService {
  LocalNotificationService([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _isInitialized = false;

  static const int _dailyReminderId = 2100;
  static const String _dailyChannelId = 'orbit_daily_channel';
  static const String _budgetChannelId = 'orbit_budget_channel';

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      tz.initializeTimeZones();
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
      } catch (_) {
        // Fallback sang múi giờ hiện tại của thiết bị nếu không tìm thấy chuỗi định danh
      }

      const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
      const darwinInit = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidInit,
        iOS: darwinInit,
      );

      await _plugin.initialize(settings: initSettings);

      // Tạo Android Channels với Importance cao
      final androidImplementation = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      if (androidImplementation != null) {
        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _dailyChannelId,
            'Nhắc nhở hằng ngày',
            description:
                'Thông báo nhắc nhở ghi chép thu chi mỗi tối lúc 21:00',
            importance: Importance.high,
          ),
        );

        await androidImplementation.createNotificationChannel(
          const AndroidNotificationChannel(
            _budgetChannelId,
            'Cảnh báo ngân sách',
            description:
                'Cảnh báo mức chi tiêu chạm ngưỡng 80% hoặc 100% ngân sách',
            importance: Importance.high,
          ),
        );
      }

      _isInitialized = true;
    } catch (e, st) {
      developer.log(
        'Không thể khởi tạo NotificationService (có thể đang chạy trong test/desktop): $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> scheduleDailyReminder({int hour = 21, int minute = 0}) async {
    try {
      if (!_isInitialized) await initialize();

      final now = tz.TZDateTime.now(tz.local);
      var scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (scheduledDate.isBefore(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 1));
      }

      const androidDetails = AndroidNotificationDetails(
        _dailyChannelId,
        'Nhắc nhở hằng ngày',
        channelDescription:
            'Thông báo nhắc nhở ghi chép thu chi mỗi tối lúc 21:00',
        importance: Importance.high,
        priority: Priority.high,
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      await _plugin.zonedSchedule(
        id: _dailyReminderId,
        title: AppStrings.dailyReminderTitle,
        body: AppStrings.dailyReminderBody,
        scheduledDate: scheduledDate,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e, st) {
      developer.log(
        'Lỗi khi lên lịch nhắc nhở hằng ngày: $e',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(id: _dailyReminderId);
    } catch (e) {
      developer.log('Lỗi khi hủy nhắc nhở: $e');
    }
  }

  @override
  Future<void> showBudgetAlert({
    required String categoryName,
    required int percent,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      // Hash id dựa trên tên danh mục và mức phần trăm để không bị ghi đè lẫn nhau
      final id = (categoryName.hashCode ^ percent).abs() % 100000;

      const androidDetails = AndroidNotificationDetails(
        _budgetChannelId,
        'Cảnh báo ngân sách',
        channelDescription:
            'Cảnh báo mức chi tiêu chạm ngưỡng 80% hoặc 100% ngân sách',
        importance: Importance.high,
        priority: Priority.high,
      );

      const darwinDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: darwinDetails,
      );

      final body = AppStrings.budgetUsageNotice(
        percent: percent,
        category: categoryName,
      );

      await _plugin.show(
        id: id,
        title: AppStrings.budgetAlertTitle,
        body: body,
        notificationDetails: notificationDetails,
      );
    } catch (e, st) {
      developer.log(
        'Lỗi khi gửi cảnh báo ngân sách: $e',
        error: e,
        stackTrace: st,
      );
    }
  }
}

/// Riverpod provider cho [NotificationService].
final notificationServiceProvider = Provider<NotificationService>((ref) {
  return LocalNotificationService();
});
