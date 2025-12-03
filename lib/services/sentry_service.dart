import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  SentryService._internal();
  static final SentryService instance = SentryService._internal();

  bool _initialized = false;

  Future<void> init() async {
    const dsn = String.fromEnvironment('SENTRY_DSN');
    if (dsn.isEmpty) return;

    await SentryFlutter.init((options) {
      options.dsn = dsn;
      options.environment = const String.fromEnvironment(
        'SENTRY_ENV',
        defaultValue: 'production',
      );
      options.tracesSampleRate = 1.0;
      options.debug = kDebugMode;
      options.appHangTimeoutInterval = const Duration(seconds: 4);
    });

    _initialized = true;
  }

  Future<void> captureException(dynamic exception, {dynamic stackTrace}) async {
    if (!_initialized) return;

    await Sentry.captureException(exception, stackTrace: stackTrace);
  }

  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
  }) async {
    if (!_initialized) return;

    await Sentry.captureMessage(message, level: level);
  }
}
