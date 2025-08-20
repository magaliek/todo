import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_settings.dart';
import '/models/task.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '/widgets/timer.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback toggle;
  final void Function(bool expanded) toggleE;
  final void Function(int i, bool expanded) toggleES;
  final VoidCallback editTask;
  final VoidCallback addSubtask;
  final VoidCallback removeTask;
  final VoidCallback launchTimer;
  final VoidCallback setDeadline;
  final VoidCallback deleteDeadline;
  final void Function(int index) launchTimerS;
  final void Function(int index) setDeadlineS;
  final void Function(int index) deleteDeadlineS;
  final void Function(int index) removeSub;
  final void Function(int index) editSub;
  final void Function(bool isDone, int index) updateSubtask;
  final VoidCallback refresh;

  const TaskTile({
    super.key,
    required this.refresh,
    required this.task,
    required this.toggle,
    required this.toggleE,
    required this.toggleES,
    required this.editTask,
    required this.editSub,
    required this.removeSub,
    required this.addSubtask,
    required this.removeTask,
    required this.launchTimer,
    required this.setDeadline,
    required this.deleteDeadline,
    required this.updateSubtask,
    required this.deleteDeadlineS,
    required this.launchTimerS,
    required this.setDeadlineS,
});


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Dismissible(
          key: ValueKey('task-${task.id}'),
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
            key: PageStorageKey('tile-${task.id}'),
            tilePadding: EdgeInsets.symmetric(horizontal: 0),
            initiallyExpanded: task.expanded,
            onExpansionChanged: (expanded) => toggleE(expanded),
            maintainState: true,
            subtitle: (task.deadline != null)
                        ? Text(
                          task.hasTime
                              ? DateFormat('dd.MM.yyyy HH.mm').format(task.deadline!)
                              : DateFormat('dd.MM.yyyy').format(task.deadline!),
                          style: TextStyle(fontSize: 10, color: settings.foregroundColor),) : null,
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
                if (task.subtasks.isNotEmpty || task.timerState!=null)
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
                PopupMenuButton<int>(
                  icon: Icon(Icons.more_vert, color: settings.foregroundColor,),
                  onSelected: (v) {
                    switch (v) {
                      case 0: editTask();
                      case 1: addSubtask();
                      case 2: launchTimer();
                      case 3: setDeadline();
                      case 4: deleteDeadline();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(value: 0, child: ListTile(leading: Icon(Icons.edit_outlined,), title: Text("Edit task"))),
                    PopupMenuItem(value: 1, child: ListTile(leading: Icon(Icons.add), title: Text("Add subtask"))),
                    PopupMenuItem(value: 2, child: ListTile(leading: Icon(Icons.timer_rounded), title: Text("Add timer"))),
                    PopupMenuItem(value: 3, child: ListTile(leading: Icon(Icons.calendar_month_rounded), title: Text("Set deadline"))),
                    PopupMenuItem(value: 4, child: ListTile(leading: Icon(Icons.auto_delete_rounded), title: Text("Delete deadline"))),
                  ],
                ),
              ],
            ),

            children: [
              if (task.timerState != null)
                TaskTimer(
                  task: task,
                  onDelete: () {
                    task.startedAt = null;
                    task.elapsed = 0;
                    task.timerState = null;
                    task.save();
                    refresh();
                  },
                ),
//come back here
                ...List.generate(task.subtasks.length, (i) {
                  final sub = task.subtasks[i];
                  return Dismissible(
                    key: ValueKey('sub-${sub.id}'),
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
                    child: ExpansionTile(
                      key: PageStorageKey('tile-sub-${sub.id}'),
                      tilePadding: EdgeInsets.symmetric(horizontal: 8.0),
                      initiallyExpanded: sub.expanded,
                      onExpansionChanged: (expanded) => toggleES(i, expanded),
                      maintainState: true,
                      subtitle: (sub.deadline != null)
                          ? Text(
                        sub.hasTime
                            ? DateFormat('dd.MM.yyyy HH.mm').format(sub.deadline!)
                            : DateFormat('dd.MM.yyyy').format(sub.deadline!),
                        style: TextStyle(fontSize: 10, color: settings.foregroundColor),) : null,

                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: sub.isDone,
                            activeColor: settings.foregroundColor,
                            onChanged: (value) => updateSubtask(value ?? false, i),
                          ),
                          if (sub.timerState != null)
                            Icon(
                              sub.expanded
                                  ? Icons.keyboard_arrow_down_rounded
                                  : Icons.keyboard_arrow_right_rounded,
                              color: settings.foregroundColor,
                            ),
                        ],
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
                      //come back here fr
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          PopupMenuButton<int>(
                            icon: Icon(Icons.more_vert, color: settings.foregroundColor,),
                            onSelected: (v) {
                              switch (v) {
                                case 0: editSub(i);
                                case 2: launchTimerS(i);
                                case 3: setDeadlineS(i);
                                case 4: deleteDeadlineS(i);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(value: 0, child: ListTile(leading: Icon(Icons.edit_outlined,), title: Text("Edit subtask"))),
                              PopupMenuItem(value: 2, child: ListTile(leading: Icon(Icons.timer_rounded), title: Text("Add timer"))),
                              PopupMenuItem(value: 3, child: ListTile(leading: Icon(Icons.calendar_month_rounded), title: Text("Set deadline"))),
                              PopupMenuItem(value: 4, child: ListTile(leading: Icon(Icons.auto_delete_rounded), title: Text("Delete deadline"))),
                            ],
                          ),
                        ],
                      ),

                      children: [
                        if (sub.timerState != null)
                          TaskTimer(
                            task: sub,
                            onDelete: () {
                              sub.startedAt = null;
                              sub.elapsed = 0;
                              sub.timerState = null;
                              sub.save();
                              refresh();
                            },
                          ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}