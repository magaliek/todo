import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '/models/task.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback toggle;
  final VoidCallback toggleE;
  final VoidCallback editTask;
  final VoidCallback addSubtask;
  final VoidCallback removeTask;
  final void Function(int index) removeSub;
  final void Function(int index) editSub;
  final void Function(bool isDone, int index) updateSubtask;

  const TaskTile({
    super.key,
    required this.task,
    required this.toggle,
    required this.toggleE,
    required this.editTask,
    required this.editSub,
    required this.removeSub,
    required this.addSubtask,
    required this.removeTask,
    required this.updateSubtask,
});


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dismissible(
          key: ValueKey(task),
          onDismissed: (_) => removeTask(),
          direction: DismissDirection.endToStart,
          background: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  settings.gradientBegin,
                  settings.gradientEnd
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(Icons.delete_outline,
                color: Colors.white),
          ),
          child: ExpansionTile(
            key: ValueKey(task),
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            initiallyExpanded: task.expanded,
            onExpansionChanged: (_) => toggleE(),
            leading: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(
                    task.isDone
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank_rounded,
                    color: settings.foregroundColor,
                  ),
                  onPressed: toggle
                ),
                Icon(
                  task.expanded
                      ? Icons.keyboard_arrow_down_rounded
                      : Icons.keyboard_arrow_right_rounded,
                  color: settings.foregroundColor,
                ),
              ],
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

            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit_outlined),
                  onPressed: editTask,
                  color: settings.taskTextColor,
                ),
                IconButton(
                  onPressed: addSubtask,
                  icon: Icon(Icons.add),
                  color: settings.taskTextColor,
                ),
              ],
            ),

            children: [
              Column(
                children: List.generate(task.subtasks.length, (i) {
                  final sub = task.subtasks[i];
                  return Dismissible(
                    key: ValueKey(sub),
                    onDismissed: (_) => removeSub(i),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            settings.gradientBegin,
                            settings.gradientEnd
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Icon(Icons.delete_outline,
                          color: Colors.white),
                    ),
                    child: ListTile(
                      leading: Checkbox(
                        value: sub.isDone,
                        activeColor: settings.foregroundColor,
                        onChanged: (value) => updateSubtask(value ?? false, i),
                      ),
                      title: Text(
                        sub.task,
                        style: GoogleFonts.getFont(
                          settings.taskFont,
                          fontSize: settings.taskTextSize,
                          decoration: sub.isDone
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: sub.isDone
                              ? Colors.grey
                              : settings.taskTextColor,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit_outlined),
                            onPressed: () => editSub(i),
                            color: settings.taskTextColor,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}