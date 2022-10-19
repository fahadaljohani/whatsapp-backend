class GroupModel {
  final String name;
  final String groupId;
  final String senderId;
  final String profilePic;
  final List<String> uidsGroupMember;
  DateTime createdAt;
  final String lastMessage;
  GroupModel({
    required this.name,
    required this.groupId,
    required this.senderId,
    required this.profilePic,
    required this.uidsGroupMember,
    required this.createdAt,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupId': groupId,
      'senderId': senderId,
      'profilePic': profilePic,
      'uidsGroupMember': uidsGroupMember,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'lastMessage': lastMessage,
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> map) {
    return GroupModel(
      name: map['name'] as String,
      groupId: map['groupId'] as String,
      senderId: map['senderId'] as String,
      profilePic: map['profilePic'] as String,
      uidsGroupMember: List<String>.from(map['uidsGroupMember']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      lastMessage: map['lastMessage'] as String,
    );
  }
}
