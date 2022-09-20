import 'package:flutter/material.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_git.dart';

class MyMessage extends StatelessWidget {
  final String text;
  final String time;
  final MessageEnum type;
  const MyMessage(
      {Key? key, required this.text, required this.time, required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.centerRight,
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
          color: messageColor,
          child: Stack(
            children: [
              Padding(
                padding: type == MessageEnum.text
                    ? const EdgeInsets.only(
                        top: 5, left: 10, bottom: 20, right: 30)
                    : const EdgeInsets.only(
                        top: 5,
                        left: 5,
                        right: 5,
                        bottom: 25,
                      ),
                child: DisplayTextImageGif(
                  message: text,
                  type: type,
                ),
              ),
              Positioned(
                  bottom: 4,
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
