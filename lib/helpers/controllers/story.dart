import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/riverpod/story.dart';
import 'package:social_feed/models/story.dart';

abstract interface class IStory {
  Future<StoryModel?> addStory(String userId, File file);
  Future<List<StoryModel>> getAllStories();
}

final storyControllerProvider = Provider.autoDispose(
  (ref) =>
      StoryController(storyNotifier: ref.watch(storyStateProvider.notifier)),
);

class StoryController implements IStory {
  final StoryNotifier _storyNotifier;

  StoryController({required StoryNotifier storyNotifier})
    : _storyNotifier = storyNotifier;
  @override
  Future<StoryModel?> addStory(String userId, File file) {
    return _storyNotifier.addStory(userId, file);
  }

  @override
  Future<List<StoryModel>> getAllStories() async {
    return _storyNotifier.getAllStories();
  }
}
