import 'package:social_feed/helpers/custom_dio.dart';

abstract interface class IStory {
  Future<List<dynamic>> getAllStories();
  Future<Map<String, dynamic>> addStory(String? userId, String imageUrl);
}

class StoriesApis implements IStory {
  final dio = ApiClient.instance;
  @override
  Future<Map<String, dynamic>> addStory(String? userId, String imageUrl) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/stories/addStory',
      data: {"userId": userId, "imageUrl": imageUrl},
    );
    final data = response.data["story"];
    if (data == null) throw Exception("story not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllStories() async {
    final response = await dio.get('http://10.0.2.2:8050/stories/');
    final data = response.data["stories"];
    if (data == null) throw Exception("stories not found in response");
    return data;
  }
}
