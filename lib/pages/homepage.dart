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
  final List<Task> _tasks = [];

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
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AppSettings>(
          builder: (context, settings, child) {
            return Column(
              children: [
                for (var i = 0; i < _tasks.length; i++)
                  Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        _tasks.remove(_tasks[i]);
                      });
                    },
                    background: Consumer<AppSettings>(
                      builder: (context, settings, child) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [settings.gradientBegin, settings.gradientEnd],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Icon(Icons.delete_outline, color: settings.foregroundColor),
                        );
                      }
                    ),

                    child: TaskTile(
                      task: _tasks[i],

                      toggle: () {
                        setState(() {
                          _tasks[i].isDone = !_tasks[i].isDone;
                        });
                      },
                      editTask:  () async {
                        final taskString = await editTask(context, _tasks[i]);
                        setState(() {
                          if (taskString != null) {
                            _tasks[i].task = taskString;
                          }
                        });
                      },
                    ),
                  ),
              ],
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final taskString = await addTask(context);
          setState(() {
            if (taskString != null) {
              _tasks.add(Task(taskString));
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}