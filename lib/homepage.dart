import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _tasks = [];

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
                  _tasks.add(value);
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
    final controller = TextEditingController(text: _tasks[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
            autofocus: true,
            onSubmitted: (value) {
              setState(() {
                _tasks[index] = controller.text;
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              //go to settings page
            },
          ),
        ],
      ),
      body:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            for (var i=0; i<_tasks.length; i++)
              Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      _tasks.remove(_tasks[i]);
                    });
                  },
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueGrey, Colors.black],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete_outline, color: Colors.white),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _tasks[i],
                        softWrap: true,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () {
                        _editTask(i);
                      },
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: const Icon(Icons.add),
      ),
    );
  }
}