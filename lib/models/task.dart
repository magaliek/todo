import '/widgets/timer.dart';

class Task {
  String task;
  bool isDone;
  List<Task> subtasks;
  bool expanded;
  TaskTimer? timer;

  Task(this.task, {
    this.isDone = false,
    List<Task>? subtasks,
    this.expanded = false,
    this.timer,
  }) : subtasks = subtasks ?? [];

  Task copyWith({
    String? task,
    bool? isDone,
    List<Task>? subtasks,
    bool? expanded,
    TaskTimer? timer,
}) {
    return Task(
      task ?? this.task,
      isDone: isDone ?? this.isDone,
      subtasks: subtasks ?? this.subtasks,
      expanded: expanded ?? this.expanded,
      timer: timer ?? this.timer,
    );
  }

  bool get areAllSubtasksDone =>
      subtasks.isNotEmpty && subtasks.every((t)=>t.isDone);

}
