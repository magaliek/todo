import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  final SharedPreferences prefs;
  AppSettings(this.prefs);

  Color backgroundColor = Color(0xFF5D0A0A);
  String backgroundImagePath = "";
  String taskFont = "Montserrat";
  double taskTextSize = 16;
  Color taskTextColor = Colors.black;
  String globalFont = "Orbitron";
  Color? foregroundColor = Colors.blueGrey[900];
  Color gradientBegin = Colors.blueGrey;
  Color gradientEnd = Colors.black;

  static Future<AppSettings> load(SharedPreferences prefs) async {
    final s = AppSettings(prefs);
    s.backgroundColor =
        Color(prefs.getInt('bgColor') ?? Colors.white.value);
    s.backgroundImagePath =
        prefs.getString('bgImagePath') ?? "";
    s.taskFont = prefs.getString('taskFont') ?? "Montserrat";
    s.taskTextSize = prefs.getDouble('taskTextSize') ?? 16;
    s.taskTextColor = Color(prefs.getInt('taskTextColor') ?? Colors.black.value);
    s.globalFont = prefs.getString('globalFont') ?? "Orbitron";
    s.foregroundColor =
        Color(prefs.getInt('foregroundColor') ?? Colors.blueGrey[900]!.value);
    s.gradientBegin = Color(prefs.getInt('gradBegin') ?? Colors.blueGrey.value);
    s.gradientEnd = Color(prefs.getInt('gradEnd') ?? Colors.black.value);
    return s;
  }

  void _saveInt(String k, int v) => prefs.setInt(k, v);
  void _saveStr(String k, String v) => prefs.setString(k, v);
  void _saveDbl(String k, double v) => prefs.setDouble(k, v);

  void setBackgroundColor(Color color) {
    backgroundColor = color;
    backgroundImagePath = "";
    _saveInt('bgColor', color.value);
    _saveStr('bgImagePath', "");
    notifyListeners();
  }

  void setBackgroundImage(String imagePath) {
    backgroundImagePath = imagePath;
    backgroundColor = Colors.transparent;
    _saveStr('bgImagePath', imagePath);
    _saveInt('bgColor', Colors.transparent.value);
    notifyListeners();
  }

  void setTaskFont(String font) {
    taskFont = font;
    _saveStr('taskFont', font);
    notifyListeners();
  }

  void setTaskTextSize(double textSize) {
    taskTextSize = textSize;
    _saveDbl('taskTextSize', textSize);
    notifyListeners();
  }

  void setTaskTextColor(Color color) {
    taskTextColor = color;
    _saveInt('taskTextColor', color.value);
    notifyListeners();
  }

  void setGlobalFont(String font) {
    globalFont = font;
    _saveStr('globalFont', font);
    notifyListeners();
  }

  void setForegroundColor(Color color) {
    foregroundColor = color;
    _saveInt('foregroundColor', color.value);
    notifyListeners();
  }

  void setGradientBegin(Color color) {
    gradientBegin = color;
    _saveInt('gradBegin', color.value);
    notifyListeners();
  }

  void setGradientEnd(Color color) {
    gradientEnd = color;
    _saveInt('gradEnd', color.value);
    notifyListeners();
  }
}