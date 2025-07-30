import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'settings_page.dart';
import 'app_settings.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppSettings(),
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings> (
      builder: (context, settings, child) {
        return MaterialApp(
          theme: ThemeData(
            scaffoldBackgroundColor: settings.backgroundColor,
            appBarTheme: AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.transparent,
              foregroundColor: settings.foregroundColor,
              titleTextStyle: GoogleFonts.getFont(
                settings.globalFont,
                fontWeight: FontWeight.bold,
                color: settings.foregroundColor,
                fontSize: 30,
              ),
            ),

            textTheme: GoogleFonts.getTextTheme(settings.taskFont).apply(
              bodyColor: settings.taskTextColor,
              displayColor: settings.foregroundColor,
            ).copyWith(
              bodyMedium: GoogleFonts.getFont(
                settings.taskFont,
                fontSize: settings.taskTextSize,
                color: settings.taskTextColor,
              )
            ),
          ),
          title: 'Todoapp',
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/settings_page': (context) => const SettingsPage(),
          },
        );
      }
    );
  }
}