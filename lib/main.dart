import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/enum/TaskState.dart';
import 'package:todo/models/task.dart';
import 'pages/homepage.dart';
import 'pages/settings_page.dart';
import 'models/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isFirstRun = prefs.getBool('has_run_before') != true;
  final settings = await AppSettings.load(prefs);

  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(TimerStateAdapter());
  await Hive.openBox<Task>('taskBox');

  runApp(
    ChangeNotifierProvider(
      create: (_) => settings,
      child: MyApp(isFirstRun: isFirstRun, prefs: prefs),
    )
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstRun;
  final SharedPreferences prefs;
  const MyApp({super.key, required this.isFirstRun, required this.prefs});

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
            '/': (context) => HomePage(isFirstRun: isFirstRun, prefs: prefs),
            '/settings_page': (context) => const SettingsPage(),
          },
        );
      }
    );
  }
}