import 'package:cltvspj/app/presentation/viewmodels/locale_viewmodel.dart';
import 'package:cltvspj/app/presentation/viewmodels/notification_viewmodel.dart';
import 'package:cltvspj/app/routes/app_routes.dart';
import 'package:cltvspj/features/clt/presentantion/viewmodels/clt_viewmodel.dart';
import 'package:cltvspj/features/home/presentation/viewmodels/home_viewmodel.dart';
import 'package:cltvspj/features/pj/presentation/viewmodels/pj_viewmodel.dart';
import 'package:cltvspj/features/user/presentation/viewmodels/user_viewmodel.dart';
import 'package:cltvspj/shared/services/notification_service.dart';
import 'package:cltvspj/shared/services/secure_service.dart';
import 'package:cltvspj/shared/services/sentry_service.dart';
import 'package:cltvspj/shared/theme/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await SentryService.instance.init();
  SecureStorageService.init();

  if (!kIsWeb) {
    await NotificationService.init();
    tz.initializeTimeZones();
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    SentryService.instance.captureException(
      details.exception,
      stackTrace: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    SentryService.instance.captureException(error, stackTrace: stack);
    return true;
  };

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
          ChangeNotifierProvider(create: (_) => NotificationViewModel()),
          ChangeNotifierProvider(create: (_) => LocaleViewModel()),
          ChangeNotifierProvider(create: (_) => HomeViewmodel()),
          ChangeNotifierProvider(create: (_) => CltViewModel()),
          ChangeNotifierProvider(create: (_) => PjViewModel()),
          ChangeNotifierProvider(create: (_) => UserViewModel()),
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
        return MaterialApp.router(
          title: 'CLT VS PJ',
          debugShowCheckedModeBanner: false,
          theme: notifier.lightTheme,
          darkTheme: notifier.darkTheme,
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: AppRoutes.router,
        );
      },
    );
  }
}
