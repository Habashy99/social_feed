import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/repository/story_repo.dart';
import 'package:social_feed/models/story.dart';

final storiesRepository = Provider<StoryRepository>((ref) => StoryRepository());
final storyStateProvider =
    StateNotifierProvider<StoryNotifier, AsyncValue<List<StoryModel>>>(
      (ref) => StoryNotifier(ref.read(storiesRepository)),
    );

class StoryNotifier extends StateNotifier<AsyncValue<List<StoryModel>>> {
  final StoryRepository storiesRepository;

  StoryNotifier(this.storiesRepository) : super(const AsyncValue.loading()) {
    getAllStories();
  }

  Future<StoryModel?> addStory(String userId, File file) async {
    try {
      final uploadedStory = await storiesRepository.addStory(userId, file.path);
      if (uploadedStory != null) {
        state.whenData((stories) {
          final story = StoryModel(
            imageUrl: file.path,
            createdAt: DateTime.now(),
          );
          final updatedStories = [...stories, story];
          _updateState(
            newState: AsyncValue.data(_cleanupExpired(updatedStories)),
          );
          return updatedStories;
        });
      }
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    return null;
  }

  List<StoryModel> _cleanupExpired(List<StoryModel> stories) {
    return stories.where((s) {
      final age = DateTime.now().difference(s.createdAt);
      return age.inHours < 24;
    }).toList();
  }

  Future<List<StoryModel>> getAllStories() async {
    try {
      final stories = await storiesRepository.getAllStories();
      final cleaned = _cleanupExpired(stories);
      _updateState(newState: AsyncValue.data(cleaned));
      return cleaned;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
      return [];
    }
  }

  void _updateState({required AsyncValue<List<StoryModel>> newState}) {
    if (mounted) {
      state = newState;
    }
  }
}
