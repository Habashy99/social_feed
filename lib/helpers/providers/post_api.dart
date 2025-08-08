import 'package:dio/dio.dart';

abstract interface class IPosts {
  createPost(String title, String? imageUrl, String userId);
  getAllPosts();
  getPostById(String id);
}

class PostsProvider implements IPosts {
  @override
  createPost(String title, String? imageUrl, String userId) async {
    final dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8050/posts/add',
      data: {"title": title, "imageUrl": imageUrl ?? "", "userId": userId},
    );
    final data = response.data["post"];
    if (data == null) throw Exception("post not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllPosts() async {
    final dio = Dio();
    final response = await dio.get('http://10.0.2.2:8050/posts/');
    final data = response.data["posts"];
    if (data == null) throw Exception("posts not found in response");
    return data;
  }

  @override
  getPostById(String id) async {
    final dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8050/posts/getPostById',
      data: {"id": id},
    );
    final data = response.data["post"];
    if (data == null) throw Exception("post not found in response");
    return data;
  }
}
