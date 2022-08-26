import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';

class SenderMessage extends StatelessWidget {
  final String text;
  final String time;
  const SenderMessage({Key? key, required this.text, required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: size.width - 45,
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          color: senderMessageColor,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 10, bottom: 20, right: 30),
                child: Text(
                  text,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Positioned(
                  bottom: 2,
                  right: 10,
                  child: Row(
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white60,
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(
                        Icons.done_all,
                        size: 20,
                        color: Colors.white60,
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
