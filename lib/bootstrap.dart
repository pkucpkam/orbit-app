import 'dart:developer' as developer;
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/app.dart';
import 'package:quy_dao/core/services/notification_service.dart';

enum AppEnvironment { dev, prod }

Future<void> bootstrap({
  required AppEnvironment environment,
  required FirebaseOptions Function() optionsBuilder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final options = optionsBuilder();
    await Firebase.initializeApp(options: options);

    // Kích hoạt Firebase App Check (Play Integrity cho Android, App Attest cho iOS)
    try {
      final isDev = environment == AppEnvironment.dev || kDebugMode;
      await FirebaseAppCheck.instance.activate(
        providerAndroid: isDev
            ? const AndroidDebugProvider()
            : const AndroidPlayIntegrityProvider(),
        providerApple: isDev
            ? const AppleDebugProvider()
            : const AppleAppAttestProvider(),
      );
    } catch (e) {
      developer.log('Firebase App Check warning (non-fatal): $e');
    }
  } catch (error, stackTrace) {
    developer.log(
      'Firebase initialization warning: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  // Khởi tạo Dịch vụ thông báo cục bộ và lên lịch nhắc nhở 21:00 (NOT-1)
  try {
    final notificationService = LocalNotificationService();
    await notificationService.initialize();
    await notificationService.scheduleDailyReminder(hour: 21, minute: 0);
  } catch (error, stackTrace) {
    developer.log(
      'NotificationService initialization warning: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  runApp(const ProviderScope(child: App()));
}
