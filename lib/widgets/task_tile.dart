import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '/models/task.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback toggle;
  final VoidCallback editTask;

  const TaskTile({
    super.key,
    required this.task,
    required this.toggle,
    required this.editTask
});


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return ListTile(
        contentPadding: EdgeInsets.only(left: 0, right: 0),
        leading: IconButton(
          icon: Icon(
            task.isDone
                ? Icons.check_box_outlined
                : Icons.check_box_outline_blank_rounded,
            color: settings.taskTextColor,
          ),
          onPressed: toggle
        ),

        title: Text(
          task.task,
          style: GoogleFonts.getFont(
            settings.taskFont,
            fontSize: settings.taskTextSize,
            decoration: task.isDone
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            color: task.isDone
                ? Colors.grey
                : settings.taskTextColor,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.edit_outlined),
          onPressed: editTask,
          color: settings.taskTextColor,
        ),
    );
  }
}