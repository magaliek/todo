class Task {
  String task;
  bool isDone;
  List<Task> subtasks;
  bool expanded;

  Task(this.task, {
    this.isDone = false,
    List<Task>? subtasks,
    this.expanded = false,
  }) : subtasks = subtasks ?? [];

  Task copyWith({
    String? task,
    bool? isDone,
    List<Task>? subtasks,
    bool? expanded
}) {
    return Task(
      task ?? this.task,
      isDone: isDone ?? this.isDone,
      subtasks: subtasks ?? this.subtasks,
      expanded: expanded ?? this.expanded,
    );
  }

  bool get areAllSubtasksDone =>
      subtasks.isNotEmpty && subtasks.every((t)=>t.isDone);

}
