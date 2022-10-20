// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CallAdapter extends TypeAdapter<Call> {
  @override
  final int typeId = 0;

  @override
  Call read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Call(
      callId: fields[0] as String,
      callerId: fields[1] as String,
      callerName: fields[2] as String,
      callerPic: fields[3] as String,
      receiverId: fields[4] as String,
      receiverName: fields[5] as String,
      receiverPic: fields[6] as String,
      hasDial: fields[7] as bool,
      createdAt: fields[8] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Call obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.callId)
      ..writeByte(1)
      ..write(obj.callerId)
      ..writeByte(2)
      ..write(obj.callerName)
      ..writeByte(3)
      ..write(obj.callerPic)
      ..writeByte(4)
      ..write(obj.receiverId)
      ..writeByte(5)
      ..write(obj.receiverName)
      ..writeByte(6)
      ..write(obj.receiverPic)
      ..writeByte(7)
      ..write(obj.hasDial)
      ..writeByte(8)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CallAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
