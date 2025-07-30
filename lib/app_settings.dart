import 'package:flutter/material.dart';

class AppSettings extends ChangeNotifier {
  Color backgroundColor = Colors.white;
  String backgroundImagePath = "";
  String taskFont = "Montserrat";
  double taskTextSize = 16;
  Color taskTextColor = Colors.black;
  String globalFont = "Orbitron";
  Color? foregroundColor = Colors.blueGrey[900];
  Color gradientBegin = Colors.blueGrey;
  Color gradientEnd = Colors.black;

  void setBackgroundColor(Color color) {
    backgroundColor = color;
    backgroundImagePath = "";
    notifyListeners();
  }

  void setBackgroundImage(String imagePath) {
    backgroundImagePath = imagePath;
    backgroundColor = Colors.transparent;
    notifyListeners();
  }

  void setTaskFont(String font) {
    taskFont = font;
    notifyListeners();
  }

  void setTaskTextSize(double textSize) {
    taskTextSize = textSize;
    notifyListeners();
  }

  void setTaskTextColor(Color color) {
    taskTextColor = color;
    notifyListeners();
  }

  void setGlobalFont(String font) {
    globalFont = font;
    notifyListeners();
  }

  void setForegroundColor(Color color) {
    foregroundColor = color;
    notifyListeners();
  }

  void setGradientBegin(Color color) {
    gradientBegin = color;
    notifyListeners();
  }

  void setGradientEnd(Color color) {
    gradientEnd = color;
    notifyListeners();
  }
}