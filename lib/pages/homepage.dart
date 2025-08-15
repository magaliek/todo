import 'package:flutter/material.dart';
import 'package:todo/models/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:todo/pages/settings_page.dart';
import '../widgets/CustomScaffold.dart';
import '/models/task.dart';
import '/dialogs/add_task_dialog.dart';
import '/dialogs/edit_task_dialog.dart';
import '/widgets/task_tile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> _tasks = [];

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
          return ListView.builder(
            itemCount: _tasks.length,
            itemBuilder: (context, i) {
              return TaskTile(
                task: _tasks[i],
                toggleE: () {
                  setState(() {
                    _tasks[i].expanded = !_tasks[i].expanded;
                  });
                },
                //tasks
                toggle: () {
                  setState(() {
                    _tasks[i].isDone = !_tasks[i].isDone;
                    if (_tasks[i].isDone) {
                      for (Task sub in _tasks[i].subtasks) {
                        sub.isDone = true;
                      }
                    } else if (!_tasks[i].isDone) {
                      for (Task sub in _tasks[i].subtasks) {
                        sub.isDone = false;
                      }
                    }
                  });
                },
                editTask: () async {
                  final taskString = await editTask(context, _tasks[i]);
                  setState(() {
                    if (taskString != null) {
                      _tasks[i].task = taskString;
                    }
                  });
                },
                removeTask: () {
                  setState(() => _tasks.removeAt(i));
                },
                //subs
                removeSub: (index) {
                  setState(() {
                    _tasks[i].subtasks.removeAt(index);
                    _tasks[i].isDone = _tasks[i].areAllSubtasksDone;
                  });
                },
                editSub: (index) async {
                  final subString = await editTask(context, _tasks[i].subtasks[index]);
                  setState(() {
                    if (subString != null) {
                      _tasks[i].subtasks[index].task = subString;
                    }
                  });
                },
                updateSubtask: (isDone, index) {
                  setState(() {
                    _tasks[i].subtasks[index].isDone = isDone;
                    _tasks[i].isDone = _tasks[i].areAllSubtasksDone;
                  });
                },
                addSubtask: () async {
                  final taskString = await addTask(context);
                  setState(() {
                    if (taskString != null) {
                      _tasks[i].isDone = false;
                      _tasks[i].subtasks.add(Task(taskString));
                    }
                  });
                },
              );
            },
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
            final taskString = await addTask(context);
            if (!mounted) return;
            if (taskString != null && taskString.trim().isNotEmpty) {
              setState(() {
                _tasks.add(Task(taskString));
              });
            }
          },
        child: const Icon(Icons.add),
      ),
    );
  }
}