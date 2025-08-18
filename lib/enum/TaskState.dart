import 'package:hive/hive.dart';

part 'TaskState.g.dart';

@HiveType(typeId: 0)
enum TimerState {
  @HiveField(0) stopped,
  @HiveField(1) running,
  @HiveField(2) paused,
}