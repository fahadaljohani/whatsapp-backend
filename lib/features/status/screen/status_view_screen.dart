import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import 'package:whatsapp/common/widgets/loader.dart';
import 'package:whatsapp/models/status.dart';

class StatusViewScreen extends StatefulWidget {
  static const String routeName = '/status-view-screen';
  final Status status;
  const StatusViewScreen({super.key, required this.status});

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen> {
  StoryController storyController = StoryController();
  final List<StoryItem> storyItem = [];

  @override
  void initState() {
    super.initState();
    initStoryItem();
  }

  void initStoryItem() {
    for (var i = 0; i < widget.status.photoUrl.length; i++) {
      storyItem.add(StoryItem.pageImage(
          url: widget.status.photoUrl[i], controller: storyController));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: storyItem.isEmpty
          ? const Loader()
          : StoryView(
              controller: storyController,
              storyItems: storyItem,
              onComplete: () => Navigator.pop(context),
              onVerticalSwipeComplete: (direction) {
                if (direction == Direction.down) {
                  Navigator.pop(context);
                }
              },
            ),
    );
  }
}
