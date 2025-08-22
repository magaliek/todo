import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo/enum/TaskState.dart';
import 'package:todo/models/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/settings_page.dart';
import '../widgets/CustomScaffold.dart';
import '/models/task.dart';
import '/dialogs/add_task_dialog.dart';
import '/dialogs/edit_task_dialog.dart';
import '/widgets/task_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  final bool isFirstRun;
  final SharedPreferences prefs;
  const HomePage({super.key, required this.isFirstRun, required this.prefs});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _tipInserted = false;
  final taskBox = Hive.box<Task>('taskBox');
  final subtaskBox = Hive.box<Task>('subtaskBox');

  @override
  void initState() {
    super.initState();

    _maybeInsertTip();
  }

  void _maybeInsertTip() {
    if (!_tipInserted && widget.isFirstRun) {
      taskBox.add(Task("💡 Tip: Swipe left to delete", subtaskBox: subtaskBox));
      widget.prefs.setBool('has_run_before', true);
      _tipInserted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('tasks'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_,__,___) => const SettingsPage(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    final offsetAnimation = Tween<Offset>(
                      begin: const Offset(1.0, 0.0),
                      end: Offset.zero,
                    ).animate(animation);

                    return SlideTransition(
                      position: offsetAnimation,
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body:
      Consumer<AppSettings>(
        builder: (context, settings, child) {
          return ValueListenableBuilder(
            valueListenable: taskBox.listenable(),
            builder: (_, Box<Task> b, __) {
              final tasks = b.values.toList(growable: false);
              return ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, i) {
                  return TaskTile(
                    task: tasks[i],
                    refresh: () => setState(() {}),
                    //tasks
                    toggleE: (expanded) {
                      setState(() {
                        tasks[i].expanded = expanded;
                        tasks[i].save();
                      });
                    },

                    toggle: () {
                      setState(() {
                        tasks[i].isDone = !tasks[i].isDone;
                        tasks[i].save();
                        for (Task sub in tasks[i].subtasks) {
                          sub.isDone = tasks[i].isDone;
                          sub.save();
                        }
                      });
                    },
                    
                    editTask: () async {
                      final taskString = await editTask(context, tasks[i]);
                      setState(() {
                        if (taskString != null) {
                          tasks[i].task = taskString;
                          tasks[i].save();
                        }
                      });
                    },
                    
                    removeTask: () async {
                      await taskBox.deleteAt(i);
                    },
                    
                    //subs
                    toggleES: (index, expanded) {
                      setState(() {
                        tasks[i].subtasks[index].expanded = expanded;
                        tasks[i].subtasks[index].save();
                      });
                    },
                    
                    removeSub: (index) {
                      final parent = tasks[i];
                      final sub = parent.subtasks[index];
                      setState(() {
                        parent.subtasks.removeAt(index);
                        parent.isDone = parent.areAllSubtasksDone;
                      });
                      parent.save();
                      sub.delete();
                    },
                    
                    editSub: (index) async {
                      final subString = await editTask(context, tasks[i].subtasks[index]);
                      setState(() {
                        if (subString != null) {
                          tasks[i].subtasks[index].task = subString;
                          tasks[i].subtasks[index].save();
                        }
                      });
                    },
                    
                    updateSubtask: (isDone, index) {
                      setState(() {
                        tasks[i].subtasks[index].isDone = isDone;
                        tasks[i].isDone = tasks[i].areAllSubtasksDone;
                        tasks[i].save();
                        tasks[i].subtasks[index].save();
                      });
                    },
                    
                    addSubtask: () async {
                      final taskString = await addTask(context);
                      setState(() {
                        if (taskString != null) {
                          final newSub = Task(taskString, subtaskBox: subtaskBox);
                          tasks[i].isDone = false;
                          subtaskBox.add(newSub);
                          tasks[i].subtasks.add(newSub);
                          tasks[i].save();
                        }
                      });
                    },

                    //time
                    launchTimerS: (index) {
                      final s = tasks[i].subtasks[index];
                      if (s.timerState == null) {
                        s.timerState = TimerState.stopped;
                        s.elapsed = 0;
                        s.startedAt = null;
                        s.save();
                        setState(() {});
                      }
                    },
                    
                    setDeadlineS: (index) async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1992),
                        lastDate: DateTime(2125),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        cancelText: "Don't set time",
                      );
                      if (!context.mounted) return;
                      final sub = tasks[i].subtasks[index];
                      if (time == null) {
                        setState(() {
                          sub.deadline = DateTime(date.year, date.month, date.day);
                          sub.hasTime = false;
                          sub.save();
                        });
                      } else {
                        setState(() {
                          sub.deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                          sub.hasTime = true;
                          sub.save();
                        });
                      }
                    },
                    
                    deleteDeadlineS: (index) {
                      final sub = tasks[i].subtasks[index];
                      setState(() {
                        sub.deadline = null;
                        sub.hasTime = false;
                        sub.save();
                      });
                    },

                    launchTimer: () {
                      final t = tasks[i];
                      if (t.timerState == null) {
                        t.timerState = TimerState.stopped;
                        t.elapsed = 0;
                        t.startedAt = null;
                        t.save();
                        setState(() {});
                      }
                    },
                    
                    deleteDeadline: () {
                      setState(() {
                        tasks[i].deadline = null;
                        tasks[i].hasTime = false;
                        tasks[i].save();
                      });
                    },

                    setDeadline: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1992),
                        lastDate: DateTime(2125),
                      );
                      if (date == null) return;
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                        cancelText: "Don't set time",
                      );
                      if (!context.mounted) return;

                      if (time == null) {
                        setState(() {
                          tasks[i].deadline = DateTime(date.year, date.month, date.day);
                          tasks[i].hasTime = false;
                          tasks[i].save();
                        });
                      } else {
                        setState(() {
                          tasks[i].deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                          tasks[i].hasTime = true;
                          tasks[i].save();
                        });
                      }
                    },
                  );
                },
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            final taskString = await addTask(context);
            if (!mounted) return;
            if (taskString != null && taskString.trim().isNotEmpty) {
              setState(() {
                taskBox.add(Task(taskString, subtaskBox: subtaskBox));
              });
            }
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}