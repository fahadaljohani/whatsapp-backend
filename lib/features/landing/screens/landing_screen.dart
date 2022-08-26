import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/widgets/custom_button.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text(
            'Welcome to ChatApp',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.height / 9,
          ),
          Image.asset(
            'assets/bg.png',
            color: tabColor,
          ),
          SizedBox(height: size.height / 9),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Read our privacy policy. Tap "AGREE AND CONTINUE" to accept the terms of service',
              style: TextStyle(fontSize: 13, color: greyColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: CustomButton(onPress: () {}, text: 'AGREE AND CONTINUE')),
        ]),
      ),
    );
  }
}
