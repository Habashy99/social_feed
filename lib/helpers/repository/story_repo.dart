import 'package:social_feed/helpers/apis/story_api.dart';
import 'package:social_feed/models/story.dart';

class StoryRepository {
  final StoriesApis _storyApis = StoriesApis();
  final StoryMapper _storyMapper = StoryMapper();
  Future<StoryModel?> addStory(String userId, String imageUrl) async {
    final json = await _storyApis.addStory(userId, imageUrl);
    final story = _storyMapper.mapFromJson(json);
    return story;
  }

  Future<List<StoryModel>> getAllStories() async {
    final json = await _storyApis.getAllStories();
    final stories = json.map((json) => _storyMapper.mapFromJson(json)).toList();
    return stories;
  }
}

abstract interface class IStoryMapper {
  StoryModel mapFromJson(Map<String, dynamic> json);
}

class StoryMapper extends IStoryMapper {
  @override
  StoryModel mapFromJson(Map<String, dynamic> json) {
    return StoryModel.fromJson(json);
  }
}
