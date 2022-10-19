import 'package:hive/hive.dart';

part 'call.g.dart';

@HiveType(typeId: 0)
class Call extends HiveObject {
  @HiveField(0)
  final String callId;
  @HiveField(1)
  final String callerId;
  @HiveField(2)
  final String callerName;
  @HiveField(3)
  final String callerPic;
  @HiveField(4)
  final String receiverId;
  @HiveField(5)
  final String receiverName;
  @HiveField(6)
  final String receiverPic;
  @HiveField(7)
  final bool hasDial;

  Call({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.receiverId,
    required this.receiverName,
    required this.receiverPic,
    required this.hasDial,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverPic': receiverPic,
      'hasDial': hasDial,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callId: map['callId'] as String,
      callerId: map['callerId'] as String,
      callerName: map['callerName'] as String,
      callerPic: map['callerPic'] as String,
      receiverId: map['receiverId'] as String,
      receiverName: map['receiverName'] as String,
      receiverPic: map['receiverPic'] as String,
      hasDial: map['hasDial'] as bool,
    );
  }
}
