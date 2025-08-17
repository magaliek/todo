import '/widgets/timer.dart';

class Task {
  String task;
  bool isDone;
  List<Task> subtasks;
  bool expanded;
  TaskTimer? timer;
  DateTime? deadline;
  bool hasTime;

  Task(this.task, {
    this.isDone = false,
    List<Task>? subtasks,
    this.expanded = false,
    this.timer,
    this.deadline,
    this.hasTime = false,
  }) : subtasks = subtasks ?? [];

  Task copyWith({
    String? task,
    bool? isDone,
    List<Task>? subtasks,
    bool? expanded,
    TaskTimer? timer,
    DateTime? deadline,
    bool? hasTime,
}) {
    return Task(
      task ?? this.task,
      isDone: isDone ?? this.isDone,
      subtasks: subtasks ?? this.subtasks,
      expanded: expanded ?? this.expanded,
      timer: timer ?? this.timer,
      deadline: deadline ?? this.deadline,
      hasTime: hasTime ?? this.hasTime,
    );
  }

  bool get areAllSubtasksDone =>
      subtasks.isNotEmpty && subtasks.every((t)=>t.isDone);

}
