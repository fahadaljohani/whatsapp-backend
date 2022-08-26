import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPress;
  final String text;
  const CustomButton({Key? key, required this.onPress, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          primary: tabColor,
          minimumSize: const Size(double.infinity, 50),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 15,
            color: blackColor,
          ),
        ));
  }
}
