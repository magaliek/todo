import 'package:flutter/material.dart';
import '/models/task.dart';

Future<String?> editTask(BuildContext context, Task task) async {
  final controller = TextEditingController(text: task.task);

  final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: (value) {
              Navigator.pop(context, value);
            },
          ),
        );
      }
  );
  return result;
}