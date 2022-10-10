// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/features/chat/widgets/display_text_image_git.dart';

class SenderMessage extends ConsumerWidget {
  final String text;
  final String time;
  final MessageEnum type;
  final String? replyMessage;
  final String? replyTo;
  final MessageEnum? replyMessageType;
  final VoidCallback onRightSwipe;
  const SenderMessage({
    super.key,
    required this.text,
    required this.time,
    required this.type,
    this.replyMessage,
    this.replyTo,
    this.replyMessageType,
    required this.onRightSwipe,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    return SwipeTo(
      onRightSwipe: onRightSwipe,
      child: Align(
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
                  padding: type == MessageEnum.text
                      ? const EdgeInsets.only(
                          top: 5, left: 10, bottom: 20, right: 30)
                      : const EdgeInsets.only(
                          top: 5,
                          left: 5,
                          right: 5,
                          bottom: 25,
                        ),
                  child: replyMessage != ''
                      ? Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: backgroundColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(5)),
                              padding: const EdgeInsets.all(10),
                              child: DisplayTextImageGif(
                                message: replyMessage!,
                                type: type,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(text),
                          ],
                        )
                      : DisplayTextImageGif(
                          message: text,
                          type: type,
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
      ),
    );
  }
}
