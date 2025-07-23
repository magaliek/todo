import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[900],
            fontFamily: 'Orbitron',
          ),
        ),
      ),

      title: 'Todoapp',
      home: Scaffold(
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
            child: TaskInput(),
          ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
              //
            },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class TaskInput extends StatefulWidget {
  const TaskInput({super.key});

  @override
  State<TaskInput> createState() => _TaskInputState();
}

class _TaskInputState extends State<TaskInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: const InputDecoration(
        hintText: "enter your task here",
        border: OutlineInputBorder(),
      ),
      onSubmitted: (value) {
        print("user entered $value");
      },
    );
  }
}
