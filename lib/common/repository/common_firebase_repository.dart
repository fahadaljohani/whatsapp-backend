// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final commonFirebaseRepositoryProvider = Provider(
  (ref) => CommonFirebaseRepository(firebaseStorage: FirebaseStorage.instance),
);

class CommonFirebaseRepository {
  final FirebaseStorage firebaseStorage;
  CommonFirebaseRepository({
    required this.firebaseStorage,
  });

  Future<String> uploadStorageToFirebse(
      {required File file, required String ref}) async {
    UploadTask uploadTask = firebaseStorage.ref(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
