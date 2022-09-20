import 'package:whatsapp/enums/message_enums.dart';

class Message {
  final String text;
  final DateTime timeSent;
  final String senderName;
  final String senderId;
  final String recieverName;
  final String recieverId;
  final String messageId;
  final bool isSeen;
  final MessageEnum type;
  Message({
    required this.text,
    required this.timeSent,
    required this.senderName,
    required this.senderId,
    required this.recieverName,
    required this.recieverId,
    required this.messageId,
    required this.isSeen,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'senderName': senderName,
      'senderId': senderId,
      'recieverName': recieverName,
      'recieverId': recieverId,
      'messageId': messageId,
      'isSeen': isSeen,
      'type': type.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      text: map['text'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      senderName: map['senderName'] as String,
      senderId: map['senderId'] as String,
      recieverName: map['recieverName'] as String,
      recieverId: map['recieverId'] as String,
      messageId: map['messageId'] as String,
      isSeen: map['isSeen'] as bool,
      type: (map['type'] as String).toEnum(),
    );
  }
}
