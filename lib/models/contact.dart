// ignore_for_file: public_member_api_docs, sort_constructors_first
class Contact {
  final String name;
  final String profilePic;
  final String lastMassage;
  final DateTime timeSent;
  final String contactId;
  Contact({
    required this.name,
    required this.profilePic,
    required this.lastMassage,
    required this.timeSent,
    required this.contactId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'lastMassage': lastMassage,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'contactId': contactId,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      name: map['name'] as String,
      profilePic: map['profilePic'] as String,
      lastMassage: map['lastMassage'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      contactId: map['contactId'] as String,
    );
  }
}
