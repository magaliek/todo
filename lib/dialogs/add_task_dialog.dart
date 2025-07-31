import 'package:flutter/material.dart';

Future<String?> addTask(BuildContext context) async {
  final TextEditingController controller = TextEditingController();

  final result = await showDialog<String>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter task'),
          autofocus: true,
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              Navigator.pop(context, value);
            }
          },
        ),
      );
    },
  );
  return result;
}