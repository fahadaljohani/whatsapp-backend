import 'dart:io';
import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/features/call/screen/calls_missed_screen.dart';
import 'package:whatsapp/features/group/screen/create_group_screen.dart';
import 'package:whatsapp/features/select_contact/screen/select_contact_screen.dart';
import 'package:whatsapp/features/chat/screen/chat_list_screen.dart';
import 'package:whatsapp/features/chat/screen/mobile_screen_layout.dart';
import 'package:whatsapp/features/status/screen/confirm_status_screen.dart';
import 'package:whatsapp/features/status/screen/status_view_screen.dart';
import 'package:whatsapp/models/status.dart';

Route<dynamic> generateRoute(RouteSettings setting) {
  switch (setting.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(builder: ((context) => const LoginScreen()));
    case OTPScreen.routeName:
      final verificationId = setting.arguments as String;
      return MaterialPageRoute(
        builder: (context) => OTPScreen(
          verificationId: verificationId,
        ),
      );
    case UserInformationScreen.routeName:
      final String verificationId = setting.arguments as String;

      return MaterialPageRoute(
        builder: ((context) =>
            UserInformationScreen(verificationId: verificationId)),
      );
    case MobileScreen.routeName:
      return MaterialPageRoute(
        builder: ((context) => const MobileScreen()),
      );
    case SelectContactScreen.routeName:
      return MaterialPageRoute(
          builder: (context) => const SelectContactScreen());
    case ChatListScreen.routeName:
      final args = setting.arguments as Map<String, dynamic>;
      final name = args['name'];
      final receiverId = args['receiverId'];
      final receiverPic = args['receiverPic'];
      final isGroupChat = args['isGroupChat'];
      return MaterialPageRoute(
          builder: (context) => ChatListScreen(
                name: name,
                receiverId: receiverId,
                receiverPic: receiverPic,
                isGroupChat: isGroupChat,
              ));
    case ConfirmStatusScreen.routeName:
      final file = setting.arguments as File;
      return MaterialPageRoute(
        builder: (context) => ConfirmStatusScreen(file: file),
      );
    case StatusViewScreen.routeName:
      final status = setting.arguments as Status;
      return MaterialPageRoute(
          builder: (context) => StatusViewScreen(status: status));
    case CraeteGroupScreen.routeName:
      return MaterialPageRoute(builder: (context) => const CraeteGroupScreen());
    case CallsMissedScreen.routeName:
      // final uid = setting.arguments as String;
      return MaterialPageRoute(builder: (context) => CallsMissedScreen());
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'this page dons\'t exists.'),
        ),
      );
  }
}
