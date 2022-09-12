import 'package:flutter/material.dart';
import 'package:whatsapp/common/widgets/error.dart';
import 'package:whatsapp/features/auth/screens/login_screen.dart';
import 'package:whatsapp/features/auth/screens/otp_screen.dart';
import 'package:whatsapp/features/auth/screens/user_information_screen.dart';
import 'package:whatsapp/features/select_contact/screen/select_contact_screen.dart';
import 'package:whatsapp/screens/chat_list_screen.dart';
import 'package:whatsapp/screens/mobile_screen_layout.dart';

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
      final uid = args['uid'];
      return MaterialPageRoute(
          builder: (context) => ChatListScreen(
                name: name,
                uid: uid,
              ));
    default:
      return MaterialPageRoute(
        builder: (context) => const Scaffold(
          body: ErrorScreen(error: 'this page dons\'t exists.'),
        ),
      );
  }
}