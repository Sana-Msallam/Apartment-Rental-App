import 'package:apartment_rental_app/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:apartment_rental_app/controller/ThemeNotifier_controller.dart';
import 'package:apartment_rental_app/screens/start.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: Sakani()));
}

class Sakani extends ConsumerWidget {
  const Sakani({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentThemeMode = ref.watch(themeProvider);

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

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Colors.white,

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF234F68),
          brightness: Brightness.light,
          surfaceTint: Colors.transparent,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF234F68),
          elevation: 4,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: textStyleDisplay.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),

        dividerTheme: DividerThemeData(
          color: Colors.grey.withOpacity(0.3),
          thickness: 1,
        ),

        textTheme: TextTheme(
          displayLarge: textStyleDisplay.copyWith(
            color: const Color(0xFF234F68),
          ),
          bodyLarge: textStyleBodyLarge.copyWith(color: Colors.black87),
          bodyMedium: textStyleBodyMedium.copyWith(color: Colors.black54),
        ),
      ),

      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1213),
        cardColor: const Color(0xFF1A1F21),
        primaryColor: const Color(0xFF234F68),

        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: const Color(0xFF234F68),
          surface: const Color(0xFF1A1F21),
          surfaceTint: Colors.transparent,
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF1A1F21),
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: textStyleDisplay.copyWith(
            color: Colors.white,
            fontSize: 20,
          ),
        ),

        dividerTheme: DividerThemeData(
          color: const Color.fromARGB(255, 170, 170, 170).withOpacity(0.2),
          thickness: 1,
        ),

        textTheme: TextTheme(
          displayLarge: textStyleDisplay.copyWith(color: Colors.white),
          bodyLarge: textStyleBodyLarge.copyWith(color: Colors.white),
          bodyMedium: textStyleBodyMedium.copyWith(color: Colors.white70),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF234F68),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),

      themeMode: currentThemeMode,
      home: StartPage(),
    );
  }
}
