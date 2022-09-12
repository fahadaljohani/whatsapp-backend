// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/repository/common_firebase_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/models/user_model.dart';

import 'package:whatsapp/screens/mobile_screen_layout.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
      ref: ref),
);

class AuthRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;
  final ProviderRef ref;
  AuthRepository({
    required this.auth,
    required this.ref,
    required this.firestore,
  });

  Future<UserModel?> getCurrentUserData() async {
    final userData =
        await firestore.collection('users').doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }
    return user;
  }

  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          throw Exception(e.message);
        },
        codeSent: (String verifictionId, int? resentToken) {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verifictionId);
        },
        codeAutoRetrievalTimeout: (e) {},
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOTP);
      await auth.signInWithCredential(credential);
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        UserInformationScreen.routeName,
        (route) => false,
        arguments: verificationId,
      );
    } on FirebaseAuthException catch (e) {
      showSnackBar(context: context, content: e.message!);
    }
  }

  void saveUserData(
      {required BuildContext context,
      required String name,
      required File? profilePic}) async {
    final uid = auth.currentUser!.uid;
    String photoUrl =
        "https://i.pinimg.com/564x/6f/61/49/6f6149e35160ea4aad3826f6016f7533.jpg";
    if (profilePic != null) {
      photoUrl = await ref
          .read(commonFirebaseRepositoryProvider)
          .uploadStorageToFirebse(file: profilePic, ref: 'profilePic/$uid');
    }
    UserModel user = UserModel(
      name: name,
      uid: uid,
      phoneNumber: auth.currentUser!.phoneNumber!,
      profilePic: photoUrl,
      isOnline: true,
      groupId: [],
    );
    await firestore.collection('users').doc(uid).set(user.toMap());
    Navigator.pushNamedAndRemoveUntil(
        context, MobileScreen.routeName, (route) => false);
  }

  Stream<UserModel> userData(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map((event) {
      return UserModel.fromMap(event.data()!);
    });
  }

  void setUserState(bool isOnline) async {
    await firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': isOnline,
    });
  }
}
