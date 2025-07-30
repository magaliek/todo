import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:todo/settings_page.dart';
import 'CustomScaffold.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class Task {
  String task;
  bool isDone;

  Task(this.task, {this.isDone = false});
}

class _HomePageState extends State<HomePage> {
  final List<Task> _tasks = [];

  void _addTask() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter task'),
            autofocus: true,
            onSubmitted: (value) {
              if (value.trim().isNotEmpty) {
                setState(() {
                  _tasks.add(Task(value));
                });
                Navigator.pop(context);
              }
            },
          ),
        );
      },
    );
  }

  void _editTask(index) {
    final controller = TextEditingController(text: _tasks[index].task);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: (value) {
              setState(() {
                _tasks[index].task = controller.text;
              });
              Navigator.pop(context);
            },
          ),
        );
      }
    );
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

                    child: ListTile(
                        contentPadding: EdgeInsets.only(left: 0, right: 0),
                        leading: IconButton(
                          icon: Icon(
                            _tasks[i].isDone
                                ? Icons.check_box_outlined
                                : Icons.check_box_outline_blank_rounded,
                            color: settings.taskTextColor,
                          ),
                          onPressed: () {
                            setState(() {
                              _tasks[i].isDone = !_tasks[i].isDone;
                            });
                          },
                        ),

                        title: Text(
                          _tasks[i].task,
                          style: GoogleFonts.getFont(
                            settings.taskFont,
                            fontSize: settings.taskTextSize,
                            decoration: _tasks[i].isDone
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: _tasks[i].isDone
                                ? Colors.grey
                                : settings.taskTextColor,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.edit_outlined),
                          onPressed: () => _editTask(i),
                          color: settings.taskTextColor,
                        )
                    ),
                  ),
              ],
            );
          }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}