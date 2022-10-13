class Status {
  final String statusId;
  final String uid;
  final String username;
  final String profilePic;
  final String phoneNumber;
  final DateTime createdAt;
  final List<String> whoCanSee;
  final List<String> photoUrl;
  Status({
    required this.statusId,
    required this.uid,
    required this.username,
    required this.profilePic,
    required this.phoneNumber,
    required this.createdAt,
    required this.whoCanSee,
    required this.photoUrl,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'statusId': statusId,
      'uid': uid,
      'username': username,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'whoCanSee': whoCanSee,
      'photoUrl': photoUrl,
    };
  }

  factory Status.fromMap(Map<String, dynamic> map) {
    return Status(
      statusId: map['statusId'] as String,
      uid: map['uid'] as String,
      username: map['username'] as String,
      profilePic: map['profilePic'] as String,
      phoneNumber: map['phoneNumber'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      whoCanSee: List<String>.from(map['whoCanSee']),
      photoUrl: List<String>.from(map['photoUrl']),
    );
  }
}
