import '/widgets/timer.dart';
import 'package:hive/hive.dart';
import 'package:todo/enum/TaskState.dart';
import 'package:uuid/uuid.dart';

part 'task.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0) String task;
  @HiveField(1) bool isDone;
  @HiveField(2) List<Task> subtasks;
  @HiveField(3) bool expanded;
  @HiveField(4) DateTime? deadline;
  @HiveField(5) bool hasTime;
  @HiveField(6) TimerState? timerState;
  @HiveField(7) DateTime? startedAt;
  @HiveField(8) int elapsed;
  @HiveField(9) String id;


  Task(this.task, {
    this.isDone = false,
    List<Task>? subtasks,
    this.expanded = false,
    this.deadline,
    this.hasTime = false,
    this.timerState,
    this.startedAt,
    this.elapsed = 0,
    String? id,
  }) : subtasks = subtasks ?? [], id = id ?? const Uuid().v4();


  Task copyWith({
    String? task,
    bool? isDone,
    List<Task>? subtasks,
    bool? expanded,
    TaskTimer? timer,
    DateTime? deadline,
    bool? hasTime,
    TimerState? timerState,
    DateTime? startedAt,
    int? elapsed,
}) {
    return Task(
      task ?? this.task,
      isDone: isDone ?? this.isDone,
      subtasks: subtasks ?? this.subtasks,
      expanded: expanded ?? this.expanded,
      deadline: deadline ?? this.deadline,
      hasTime: hasTime ?? this.hasTime,
      timerState: timerState ?? this.timerState,
      startedAt: startedAt ?? this.startedAt,
      elapsed: elapsed ?? this.elapsed,
    );
  }

  bool get areAllSubtasksDone =>
      subtasks.isNotEmpty && subtasks.every((t)=>t.isDone);

}
