import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/pet_provider.dart';
import 'screens/home_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize local offline storage
  final storageService = await StorageService.create();

  // 2. Initialize local notifications
  await NotificationService.instance.init();

  // 3. Schedule daily streak reminder (at 20:00) if enabled
  if (storageService.isDailyReminderEnabled()) {
    await NotificationService.instance.scheduleDailyStreakReminder();
  }

  runApp(
    ProviderScope(
      overrides: [
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const SelfFocusPixelApp(),
    ),
  );
}

class SelfFocusPixelApp extends StatelessWidget {
  const SelfFocusPixelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Focus Pixel',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5F9),
        fontFamily: 'monospace',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFFA520F), // Mistral Orange
          secondary: Color(0xFFFFAF00), // Pixel Amber
          surface: Colors.white,
          error: Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSurface: Color(0xFF1E1E1E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'monospace',
            fontWeight: FontWeight.w900,
            fontSize: 15,
            color: Color(0xFF1E1E1E),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
