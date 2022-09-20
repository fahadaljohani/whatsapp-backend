// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:whatsapp/features/auth/repository/auth_repository.dart';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp/models/user_model.dart';

final authControllerProvider = Provider((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AuthController(authRepository: authRepository);
});

final getUserDataControllerProvider = FutureProvider(((ref) {
  final userController = ref.watch(authControllerProvider);
  return userController.getCurrentUserData();
}));

class AuthController {
  final AuthRepository authRepository;
  AuthController({
    required this.authRepository,
  });
  void signInWithPhone(BuildContext context, String phoneNumber) {
    authRepository.signInWithPhone(context, phoneNumber);
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String userOTP,
  }) {
    authRepository.verifyOTP(
        context: context, verificationId: verificationId, userOTP: userOTP);
  }

  void saveUserData(
      {required BuildContext context, required String name, File? profilePic}) {
    authRepository.saveUserData(
        context: context, name: name, profilePic: profilePic);
  }

  Future<UserModel?> getCurrentUserData() async {
    UserModel? user = await authRepository.getCurrentUserData();
    return user;
  }

  Stream<UserModel?> getUserById(String userId) {
    return authRepository.userData(userId);
  }

  void setUserState(bool isOnline) {
    authRepository.setUserState(isOnline);
  }
}
