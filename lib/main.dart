import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/providers/ThemeNotifier_controller.dart';
import 'package:apartment_rental_app/screens/home_screen.dart';
import 'package:apartment_rental_app/screens/apartment_details_screen.dart';
import 'package:apartment_rental_app/screens/booking_screen.dart';
import 'package:apartment_rental_app/screens/start.dart';
import 'package:apartment_rental_app/models/apartment_details_model.dart';
import 'package:apartment_rental_app/services/local_notifications_service.dart';
import 'package:apartment_rental_app/services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // ضروري جداً للترجمة
import 'package:apartment_rental_app/providers/apartment_home_provider.dart'; // أو المسار الذي وضعتِ فيه كود الـ Providers
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeDateFormatting('en', null);
  } catch (e) {
    print('Initialization failed: $e');
  }
  await const FlutterSecureStorage().deleteAll();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);

  runApp(
    ProviderScope(
      child: Sakani(),
    ),
  );
}
class Sakani extends ConsumerWidget {
  const Sakani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final isAr = ref.watch(isArabicProvider); // قمنا بتعريف isAr هنا

    // 2. الستايلات
    const textStyleDisplay = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24,
      letterSpacing: 0.8,
    );
    const textStyleBodyLarge = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    const textStyleBodyMedium = TextStyle(
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sakani App',

      // ✅ إعدادات اللغة (مرة واحدة فقط وبشكل صحيح)
      locale: isAr ? const Locale('ar') : const Locale('en'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],

      themeMode: currentThemeMode,

      // ثيم الفاتح
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF234F68),
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF234F68),
          elevation: 4,
          centerTitle: true,
          titleTextStyle: textStyleDisplay.copyWith(color: Colors.white, fontSize: 20),
        ),
        textTheme: TextTheme(
          displayLarge: textStyleDisplay.copyWith(color: const Color(0xFF234F68)),
          bodyLarge: textStyleBodyLarge.copyWith(color: Colors.black87),
          bodyMedium: textStyleBodyMedium.copyWith(color: Colors.black54),
        ),
      ),

      // ثيم الداكن
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1213),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF234F68),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A1F21),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: textStyleDisplay.copyWith(color: Colors.white, fontSize: 20),
        ),
        textTheme: TextTheme(
          displayLarge: textStyleDisplay.copyWith(color: Colors.white),
          bodyLarge: textStyleBodyLarge.copyWith(color: Colors.white),
          bodyMedium: textStyleBodyMedium.copyWith(color: Colors.white),
        ),
      ),

      home:  StartPage(),
    );
  }
}