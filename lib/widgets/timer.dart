import 'dart:async';
import 'package:flutter/material.dart';
import 'package:todo/models/app_settings.dart';
import 'package:provider/provider.dart';


enum TimerStatus {stopped, running, paused}

class TaskTimer extends StatefulWidget {
  final VoidCallback? onDelete;

  const TaskTimer({super.key, this.onDelete});

  @override
  State<TaskTimer> createState() => _TaskTimerState();
}

class _TaskTimerState extends State<TaskTimer> {
  Timer? _timer;
  Duration _elapsed = Duration.zero;
  TimerStatus _status = TimerStatus.stopped;
  final Key _dismissKey = UniqueKey();


  void start() {
    if (_status == TimerStatus.running) return;

    _timer?.cancel();
    _timer = Timer.periodic(Duration(milliseconds: 1), (_) {
      setState(() {
        _elapsed += Duration(milliseconds: 1);
      });
    });

    setState(() => _status = TimerStatus.running);
  }

  void pause() {
    if (_status != TimerStatus.running) return;
    _timer?.cancel();
    _timer = null;
    setState(() => _status = TimerStatus.paused);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _status = TimerStatus.stopped;
      _elapsed = Duration.zero;
    });
  }

  void deleteTimer() {
    stop();
    widget.onDelete!();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(Duration d) {
    final days = d.inDays.remainder(365).toString();
    final h = d.inHours.remainder(24).toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final ms = d.inMilliseconds.remainder(1000).toString().padLeft(4, '0');
    return d.inDays.remainder(365)>0
        ? '$days:$h:$m:$s:$ms'
        : '$h:$m:$s:$ms';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _status == TimerStatus.running;
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
            _fmt(_elapsed),
            style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
          ),

          IconButton(
            icon: Icon(isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded),
            onPressed: isRunning ? pause : start,
          ),

          IconButton(
            icon: Icon(Icons.stop_rounded),
            onPressed: stop,
          ),
        ],
      ),
    );
  }

}