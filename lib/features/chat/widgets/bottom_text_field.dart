import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp/colors.dart';
import 'package:whatsapp/common/utils/utils.dart';
import 'package:whatsapp/enums/message_enums.dart';
import 'package:whatsapp/features/chat/controller/chat_controller.dart';
import 'package:whatsapp/features/chat/widgets/reply_message_preview.dart';
import 'package:whatsapp/provider/message_reply_provider.dart';

class BottomTextField extends ConsumerStatefulWidget {
  final String recieverId;
  final bool isGroupChat;
  const BottomTextField({
    Key? key,
    required this.recieverId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends ConsumerState<BottomTextField> {
  final TextEditingController messageController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FlutterSoundRecorder? soundPlayer;
  bool audioInit = false;
  bool isRecording = false;

  @override
  void initState() {
    super.initState();
    soundPlayer = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    var state = await Permission.microphone.request();
    if (state != PermissionStatus.granted) {
      throw RecordingPermissionException('mic access not allowed.');
    }
    soundPlayer!.openRecorder();
    audioInit = true;
  }

  void sendTextMessage(
      String recieverId, String text, MessageEnum messageEnum) {
    ref.read(chatControllerProvider).sendTextMessge(
          context: context,
          recieverId: recieverId,
          text: text,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupChat,
        );
  }

  void sendFileMessage({
    required File file,
    required MessageEnum messageEnum,
  }) {
    ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          recieverId: widget.recieverId,
          file: file,
          messageEnum: messageEnum,
          isGroupChat: widget.isGroupChat,
        );
  }

  void sendImageFile() {
    pickImageFromGallery().then((value) {
      if (value != null) {
        ref.read(chatControllerProvider).sendFileMessage(
              context: context,
              recieverId: widget.recieverId,
              file: value,
              messageEnum: MessageEnum.image,
              isGroupChat: widget.isGroupChat,
            );
      }
    });
  }

  void sendVideoFile() {
    pickVideoFromGallery().then((value) {
      if (value != null) {
        ref.read(chatControllerProvider).sendFileMessage(
              context: context,
              recieverId: widget.recieverId,
              file: value,
              messageEnum: MessageEnum.video,
              isGroupChat: widget.isGroupChat,
            );
      }
    });
  }

  bool isShowSendButton = false;
  bool isShowEmojiKeyboard = false;

  void showEmojiKeyboard() {
    setState(() {
      isShowEmojiKeyboard = true;
    });
  }

  void hideEmojiKeyboard() {
    setState(() {
      isShowEmojiKeyboard = false;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();
  void toggleEmojiKeyboard() {
    if (isShowEmojiKeyboard) {
      showKeyboard();
      hideEmojiKeyboard();
    } else {
      hideKeyboard();
      showEmojiKeyboard();
    }
  }

  // - dispose
  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
    focusNode.dispose();
    soundPlayer!.closeRecorder();
    audioInit = false;
  }

  @override
  Widget build(BuildContext context) {
    var replyedMessage = ref.watch(messageRepyProvider);
    return Column(
      children: [
        replyedMessage != null
            ? MessageReplyPreview(
                replyedMessage: replyedMessage.replyMessage,
                isMe: replyedMessage.isMe,
                messageEnum: replyedMessage.replyType,
              )
            : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: messageController,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        const BorderSide(width: 0, style: BorderStyle.none),
                  ),
                  // fillColor: searchBarColor,
                  // filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboard,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: greyColor,
                            ),
                          ),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.gif))
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: sendImageFile,
                            icon: const Icon(
                              Icons.camera_alt,
                              color: greyColor,
                            ),
                          ),
                          IconButton(
                            onPressed: sendVideoFile,
                            icon: const Icon(
                              Icons.attach_file,
                              color: greyColor,
                            ),
                          ),
                        ]),
                  ),
                  hintText: 'type a message',
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2, right: 2, bottom: 8),
              child: GestureDetector(
                onTap: () async {
                  if (isShowSendButton) {
                    sendTextMessage(widget.recieverId,
                        messageController.text.trim(), MessageEnum.text);
                    setState(() {
                      messageController.text = "";
                    });
                  } else {
                    if (!audioInit) return;
                    final tmpDir = await getTemporaryDirectory();
                    var path = '${tmpDir.path}/flutter_sound.aac';
                    if (isRecording) {
                      await soundPlayer!.stopRecorder();
                      sendFileMessage(
                          file: File(path), messageEnum: MessageEnum.audio);
                      setState(() => isRecording = false);
                    } else {
                      await soundPlayer!.startRecorder(toFile: path);
                      setState(() => isRecording = true);
                    }
                  }
                },
                child: CircleAvatar(
                  backgroundColor: const Color(0xFFF128C7E),
                  radius: 25,
                  child: isShowSendButton
                      ? const Icon(
                          Icons.send,
                          color: whiteColor,
                        )
                      : isRecording
                          ? const Icon(Icons.close)
                          : const Icon(
                              Icons.mic,
                              color: whiteColor,
                            ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiKeyboard
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  textEditingController: messageController,
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      messageController.text =
                          messageController.text + emoji.emoji;
                    });
                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  },
                  onBackspacePressed: () {
                    messageController.text = "";
                  },
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
