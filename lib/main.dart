import 'package:cltvspj/controller/controllers/calculator_controller.dart';
import 'package:cltvspj/controller/controllers/clt_controller.dart';
import 'package:cltvspj/controller/controllers/locale_controller.dart';
import 'package:cltvspj/controller/controllers/notification_controller.dart';
import 'package:cltvspj/controller/controllers/pj_controller.dart';
import 'package:cltvspj/controller/controllers/user_controller.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/services/notification_service.dart';
import 'package:cltvspj/services/secure_service.dart';
import 'package:cltvspj/services/sentry_service.dart';
import 'package:cltvspj/views/app_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  SecureStorageService.init();

  if (!kIsWeb) {
    await SentryService.instance.init();

    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      SentryService.instance.captureException(
        details.exception,
        stackTrace: details.stack,
      );
    };
  } else {
    FlutterError.onError = FlutterError.dumpErrorToConsole;
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en-US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotificationController()),
          ChangeNotifierProvider(create: (_) => LocaleController()),
          ChangeNotifierProvider(create: (_) => CalculatorController()),
          ChangeNotifierProvider(create: (_) => CltController()),
          ChangeNotifierProvider(create: (_) => PjController()),
          ChangeNotifierProvider(create: (_) => UserController()),
          ChangeNotifierProvider(create: (_) => UiProvider()..init()),
        ],
        child: const AppWidget(),
      ),
    ),
  );
}

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return MaterialApp(
          title: 'CLT VS PJ',
          debugShowCheckedModeBanner: false,
          theme: notifier.lightTheme,
          darkTheme: notifier.darkTheme,
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: AppPage(),
        );
      },
    );
  }
}
