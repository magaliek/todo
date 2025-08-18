import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/models/app_settings.dart';
import 'package:provider/provider.dart';
import 'package:todo/models/task.dart';
import 'package:todo/enum/TaskState.dart';
import '../notifs/ios_live_activity.dart';


class TaskTimer extends StatefulWidget {
  final Task task;
  final VoidCallback? onDelete;

  const TaskTimer({super.key, this.onDelete, required this.task});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  Timer? _tick;
  final Key _dismissKey = UniqueKey();

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _tick?.cancel();
    _tick = Timer.periodic(Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  Duration get _displayElapsed {
    final t = widget.task;
    final base = Duration(seconds: t.elapsed);
    if (t.timerState == TimerState.running && t.startedAt != null) {
      return base + DateTime.now().difference(t.startedAt!);
    }
    return base;
  }

  String _fmt(Duration d) {
    final days = d.inDays.remainder(365).toString();
    final h = d.inHours.remainder(24).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return d.inDays.remainder(365)>0
        ? '$days:$h:$m:$s'
        : '$h:$m:$s';
  }

  void _start() {
    final t = widget.task;
    if (t.timerState == TimerState.running) return;
    t.startedAt = DateTime.now();
    t.timerState = TimerState.running;
    t.save();

    IosLiveActivity.startTimerActivity(
      taskId: t.id,
      title: t.task,
      elapsed: t.elapsed,
    );
  }

  void _pause() {
    final t = widget.task;
    if (t.timerState != TimerState.running || t.startedAt == null) return;
    t.elapsed += DateTime.now().difference(t.startedAt!).inSeconds;
    t.startedAt = null;
    t.timerState = TimerState.paused;
    t.save();

    IosLiveActivity.updateTimerActivity(
      taskId: t.id,
      elapsed: t.elapsed,
      isRunning: false,
      startedAt: null,
    );
  }

  void _stop() {
    final t = widget.task;
    t.startedAt = null;
    t.elapsed = 0;
    t.timerState = TimerState.stopped;
    t.save();

    IosLiveActivity.endTimerActivity();
  }

  void deleteTimer() {
    _stop();
    widget.onDelete!();
  }


  @override
  Widget build(BuildContext context) {
    final isRunning = widget.task.timerState == TimerState.running;
    final settings = context.watch<AppSettings>();

    return Dismissible(
      key: _dismissKey,
      direction: DismissDirection.endToStart,
      onDismissed: (_) => deleteTimer(),
      background: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              settings.gradientBegin,
              settings.gradientEnd
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(Icons.delete_outline,
            color: Colors.white),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _fmt(_displayElapsed),
            style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
          ),

          IconButton(
            icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
            onPressed: isRunning ? _pause : _start,
            color: settings.foregroundColor,
          ),

          IconButton(
            icon: Icon(Icons.stop_rounded),
            onPressed: _stop,
            color: settings.foregroundColor,
          ),
        ],
      ),
    );
  }

}