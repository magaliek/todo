// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TaskState.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimerStateAdapter extends TypeAdapter<TimerState> {
  @override
  final int typeId = 0;

  @override
  TimerState read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TimerState.stopped;
      case 1:
        return TimerState.running;
      case 2:
        return TimerState.paused;
      default:
        return TimerState.stopped;
    }
  }

  @override
  void write(BinaryWriter writer, TimerState obj) {
    switch (obj) {
      case TimerState.stopped:
        writer.writeByte(0);
        break;
      case TimerState.running:
        writer.writeByte(1);
        break;
      case TimerState.paused:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
