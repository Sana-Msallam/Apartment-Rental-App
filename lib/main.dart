import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:apartment_rental_app/constants/app_string.dart';
import 'package:apartment_rental_app/controller/ThemeNotifier_controller.dart';
import 'package:apartment_rental_app/screens/home_screen.dart';
import 'package:apartment_rental_app/screens/start.dart';
import 'package:apartment_rental_app/services/local_notifications_service.dart';
import 'package:apartment_rental_app/services/push_notifications_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // تعديل: استخدام SecureStorage
import 'package:intl/date_symbol_data_local.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الوقت واللغة
  try {
    await initializeDateFormatting('en', null);
  } catch (e) {
    debugPrint('Initialization failed: $e');
  }

  // تهيئة فايربيز
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ التعديل الجوهري: القراءة من SecureStorage ليتوافق مع شاشة التفاصيل والـ ApiService لديكِ
  const storage = FlutterSecureStorage();
  final String? savedToken = await storage.read(key: 'jwt_token');

  // تهيئة الإشعارات
  await Future.wait([
    PushNotificationsService.init(),
    LocalNotificationService.init(),
  ]);

  runApp(
    ProviderScope(
      child: Sakani(token: savedToken),
    ),
  );
}

class Sakani extends ConsumerWidget {
  final String? token;
  const Sakani({super.key, this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);
    final isAr = ref.watch(isArabicProvider);

    // الستايلات الموحدة
    const textStyleDisplay = TextStyle(
      fontWeight: FontWeight.w900,
      fontSize: 24,
      letterSpacing: 0.8,
    );
    const textStyleBodyLarge = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sakani App',

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

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF234F68),
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF234F68),
          elevation: 4,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
          displayLarge: textStyleDisplay.copyWith(color: const Color(0xFF234F68)),
          bodyLarge: textStyleBodyLarge.copyWith(color: Colors.black87),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1213),
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF234F68),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1F21),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        textTheme: TextTheme(
          displayLarge: textStyleDisplay.copyWith(color: Colors.white),
          bodyLarge: textStyleBodyLarge.copyWith(color: Colors.white),
        ),
      ),

      // ✅ الآن هذا السطر سيعمل بشكل صحيح لأن الـ token قادم من نفس مفتاح شاشة التفاصيل
      home: (token != null && token!.isNotEmpty) 
          ? const HomeScreen() 
          :  StartPage(),
    );
  }
}