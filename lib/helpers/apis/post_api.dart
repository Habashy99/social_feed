import 'package:social_feed/helpers/custom_dio.dart';

abstract interface class IPosts {
  createPost(String title, String? imageUrl, String userId);
  getAllPosts(String userId);
  getPostById(String id, String userId);
  Future<List<dynamic>> getAllPostsByUserId(String userId);
}

class PostsApis implements IPosts {
  final dio = ApiClient.instance;
  @override
  createPost(String text, String? imageUrl, String userId) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/posts/add',
      data: {"text": text, "imageUrl": imageUrl ?? "", "userId": userId},
    );
    final data = response.data["post"];
    if (data == null) throw Exception("post not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllPosts(String userId) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/posts/',
      data: {"userId": userId},
    );
    final data = response.data["posts"];
    if (data == null) throw Exception("posts not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllPostsByUserId(String userId) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/posts/getAllPostsByUserId',
      data: {"userId": userId},
    );
    final data = response.data["posts"];
    if (data == null) throw Exception("posts not found in response");
    return data;
  }

  @override
  getPostById(String id, String userId) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/posts/getPostById',
      data: {"id": id, "userId": userId},
    );
    final data = response.data["post"];
    if (data == null) throw Exception("post not found in response");
    return data;
  }
}
