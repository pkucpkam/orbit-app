import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quy_dao/app.dart';

enum AppEnvironment { dev, prod }

Future<void> bootstrap({
  required AppEnvironment environment,
  required FirebaseOptions Function() optionsBuilder,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final options = optionsBuilder();
    await Firebase.initializeApp(options: options);
    // TODO: Kích hoạt Firebase App Check (Play Integrity cho Android, App Attest cho iOS)
  } catch (error, stackTrace) {
    developer.log(
      'Firebase initialization warning: $error',
      error: error,
      stackTrace: stackTrace,
    );
  }

  runApp(const ProviderScope(child: App()));
}
