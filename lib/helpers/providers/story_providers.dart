import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/story.dart';
import 'package:social_feed/models/story.dart';

final storiesProvider = FutureProvider.autoDispose<List<StoryModel>>((
  ref,
) async {
  final storiesController = ref.watch(storyControllerProvider);
  final stories = await storiesController.getAllStories();
  return stories;
});
final addStoryProvider = FutureProvider.autoDispose
    .family<StoryModel?, ({String userId, File image})>((ref, args) async {
      final storiesController = ref.watch(storyControllerProvider);
      final story = await storiesController.addStory(args.userId, args.image);
      return story;
    });
