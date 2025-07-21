import 'package:cltvspj/controller/calculator_controller.dart';
import 'package:cltvspj/controller/clt_controller.dart';
import 'package:cltvspj/controller/locale_controller.dart';
import 'package:cltvspj/controller/notification_controller.dart';
import 'package:cltvspj/controller/pj_controller.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/services/notification_service.dart';
import 'package:cltvspj/services/secure_service.dart';
import 'package:cltvspj/views/app_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_10y.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await NotificationService.init();
  tz.initializeTimeZones();
  SecureStorageService.init();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('pt', 'BR'),
        Locale('es'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => NotificationController()),
          ChangeNotifierProvider(create: (_) => LocaleController()),
          ChangeNotifierProvider(create: (_) => CalculatorController()),
          ChangeNotifierProvider(create: (_) => CltController()),
          ChangeNotifierProvider(create: (_) => PjController()),
          ChangeNotifierProvider(create: (_) => UiProvider()..init()),
        ],
        child: ModularApp(module: AppModule(), child: const AppWidget()),
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
      builder: (context, UiProvider notifier, child) {
        return MaterialApp.router(
          title: 'CLT VS PJ',
          debugShowCheckedModeBanner: false,
          theme: notifier.lightTheme,
          darkTheme: notifier.darkTheme,
          themeMode: notifier.isDark ? ThemeMode.dark : ThemeMode.light,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          routerConfig: Modular.routerConfig,
        );
      },
    );
  }
}

class AppModule extends Module {
  @override
  void binds(i) {}

  @override
  void routes(r) {
    r.child('/', child: (context) => const AppPage());
  }
}
