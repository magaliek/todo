import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import 'dart:io';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButton;

  const CustomScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.floatingActionButton
  });

  @override
  Widget build(BuildContext context) {
    final appSettings = context.watch<AppSettings>();

    if (appSettings.backgroundImagePath.isNotEmpty) {
      precacheImage(
        FileImage(
          File(appSettings.backgroundImagePath),
        ),
        context,
      );
    }

    return Stack(
      children: [
        Positioned.fill(
          child: appSettings.backgroundImagePath.isNotEmpty
              ? Image.file(
            File(appSettings.backgroundImagePath),
            fit: BoxFit.cover,
            color: const Color.fromRGBO(0, 0, 0, 0.4),
            colorBlendMode: BlendMode.darken,
          )
              : Container(color: appSettings.backgroundColor),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: appBar,
          body: SafeArea(
              child: SingleChildScrollView(
                  child: body,
              )
          ),
          floatingActionButton: floatingActionButton,
        ),
      ],
    );

  }
}