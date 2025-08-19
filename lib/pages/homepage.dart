import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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
import 'package:todo/widgets/timer.dart';


class HomePage extends StatefulWidget {
  final bool isFirstRun;
  final SharedPreferences prefs;
  const HomePage({super.key, required this.isFirstRun, required this.prefs});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _tipInserted = false;
  final box = Hive.box<Task>('taskBox');

  @override
  void initState() {
    super.initState();

    _maybeInsertTip();
  }

  void _maybeInsertTip() {
    if (!_tipInserted && widget.isFirstRun) {
      box.add(Task("💡 Tip: Swipe left to delete"));
      widget.prefs.setBool('has_run_before', true);
      _tipInserted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: const Text('tasks'),
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
            valueListenable: box.listenable(),
            builder: (_, Box<Task> b, __) {
              final tasks = b.values.toList(growable: false);
              return ListView.builder(
                itemCount: box.length,
                itemBuilder: (context, i) {
                  return TaskTile(
                    task: tasks[i],
                    toggleE: () {
                      setState(() {
                        tasks[i].expanded = !tasks[i].expanded;
                        tasks[i].save();
                      });
                    },
                    //tasks
                    toggle: () {
                      setState(() {
                        tasks[i].isDone = !tasks[i].isDone;
                        tasks[i].save();
                        if (tasks[i].isDone) {
                          for (Task sub in tasks[i].subtasks) {
                            sub.isDone = true;
                            tasks[i].save();
                          }
                        } else if (!tasks[i].isDone) {
                          for (Task sub in tasks[i].subtasks) {
                            sub.isDone = false;
                            tasks[i].save();
                          }
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
                      await box.deleteAt(i);
                    },
                    //subs
                    removeSub: (index) {
                      setState(() {
                        tasks[i].subtasks.removeAt(index);
                        tasks[i].isDone = tasks[i].areAllSubtasksDone;
                        tasks[i].save();
                      });
                    },
                    editSub: (index) async {
                      final subString = await editTask(context, tasks[i].subtasks[index]);
                      setState(() {
                        if (subString != null) {
                          tasks[i].subtasks[index].task = subString;
                          tasks[i].save();
                        }
                      });
                    },
                    updateSubtask: (isDone, index) {
                      setState(() {
                        tasks[i].subtasks[index].isDone = isDone;
                        tasks[i].isDone = tasks[i].areAllSubtasksDone;
                        tasks[i].save();
                      });
                    },
                    addSubtask: () async {
                      final taskString = await addTask(context);
                      setState(() {
                        if (taskString != null) {
                          tasks[i].isDone = false;
                          tasks[i].subtasks.add(Task(taskString));
                          tasks[i].save();
                        }
                      });
                    },
                    //time
                    launchTimer: () {
                      final t = tasks[i];
                      if (t.timerState == null) {
                        t.timerState = TimerState.stopped;
                        t.elapsed = 0;
                        t.startedAt = null;
                        // Persist AND notify listeners:
                        box.putAt(i, t); // <- guarantees ValueListenableBuilder fires
                        t.save();
                        setState(() {}); // <- ensures immediate rebuild on device too
                      }
                    },
                    //lastly
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
                box.add(Task(taskString));
              });
            }
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}