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
                    task: box.getAt(i)!,
                    toggleE: () {
                      setState(() {
                        box.getAt(i)!.expanded = !box.getAt(i)!.expanded;
                      });
                    },
                    //tasks
                    toggle: () {
                      setState(() {
                        box.getAt(i)!.isDone = !box.getAt(i)!.isDone;
                        if (box.getAt(i)!.isDone) {
                          for (Task sub in box.getAt(i)!.subtasks) {
                            sub.isDone = true;
                          }
                        } else if (!box.getAt(i)!.isDone) {
                          for (Task sub in box.getAt(i)!.subtasks) {
                            sub.isDone = false;
                          }
                        }
                      });
                    },
                    editTask: () async {
                      final taskString = await editTask(context, box.getAt(i)!);
                      setState(() {
                        if (taskString != null) {
                          box.getAt(i)!.task = taskString;
                        }
                      });
                    },
                    removeTask: () {
                      setState(() => box.deleteAt(i));
                    },
                    //subs
                    removeSub: (index) {
                      setState(() {
                        box.getAt(i)!.subtasks.removeAt(index);
                        box.getAt(i)!.isDone = box.getAt(i)!.areAllSubtasksDone;
                      });
                    },
                    editSub: (index) async {
                      final subString = await editTask(context, box.getAt(i)!.subtasks[index]);
                      setState(() {
                        if (subString != null) {
                          box.getAt(i)!.subtasks[index].task = subString;
                        }
                      });
                    },
                    updateSubtask: (isDone, index) {
                      setState(() {
                        box.getAt(i)!.subtasks[index].isDone = isDone;
                        box.getAt(i)!.isDone = box.getAt(i)!.areAllSubtasksDone;
                      });
                    },
                    addSubtask: () async {
                      final taskString = await addTask(context);
                      setState(() {
                        if (taskString != null) {
                          box.getAt(i)!.isDone = false;
                          box.getAt(i)!.subtasks.add(Task(taskString));
                        }
                      });
                    },
                    //time
                    launchTimer: () {
                      final t = box.getAt(i)!;

                      if (t.timerState == null) {
                        t.timerState = TimerState.stopped;
                        t.elapsed = 0;
                        t.startedAt = null;
                        t.save();
                      }
                    },
                    //lastly
                    deleteDeadline: () {
                      setState(() {
                        box.getAt(i)!.deadline = null;
                        box.getAt(i)!.hasTime = false;
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
                          box.getAt(i)!.deadline = DateTime(date.year, date.month, date.day);
                          box.getAt(i)!.hasTime = false;
                        });
                      } else {
                        setState(() {
                          box.getAt(i)!.deadline = DateTime(date.year, date.month, date.day, time.hour, time.minute);
                          box.getAt(i)!.hasTime = true;
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