//ios_live_activity.dart

import 'dart:convert';
import 'dart:io';
import 'package:live_activities/live_activities.dart';

class IosLiveActivity {
  static final _plugin = LiveActivities();
  static String? _activityId;

  static Future<void> startTimerActivity({
    required String taskId,
    required String title,
    required int elapsed,
  }) async {
    if (!Platform.isIOS) return;

    final attrs = jsonEncode({
      "title": title,
    });

    final state = {
      "taskId": taskId,
      "elapsed": elapsed,
      "isRunning": true,
      "startedAt": DateTime.now().toIso8601String(),
    };

    _activityId = await _plugin.createActivity(attrs, state);
  }

  static Future<void> updateTimerActivity({
    required String taskId,
    required int elapsed,
    required bool isRunning,
    DateTime? startedAt,
  }) async {
    if (!Platform.isIOS || _activityId == null) return;

    final state = <String, dynamic>{
      "taskId": taskId,
      "elapsed": elapsed,
      "isRunning": isRunning,
      if (startedAt != null) "startedAt": startedAt.toIso8601String(),
    };

    await _plugin.updateActivity(_activityId!, state);
  }

  static Future<void> endTimerActivity() async {
    if (!Platform.isIOS || _activityId == null) return;
    await _plugin.endActivity(_activityId!);
    _activityId = null;
  }
}