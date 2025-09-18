import 'package:social_feed/helpers/custom_dio.dart';

abstract interface class IComments {
  createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  );
  getAllComments();
  getCommentById(String id);
  getAllCommentsByUserId(String userId);
  getAllCommentsByPostId(String postId, String userId);
}

class CommentsApis implements IComments {
  final dio = ApiClient.instance;
  @override
  createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/comments/add',
      data: {
        "commentText": comment,
        "commentPhoto": commentPhoto ?? "",
        "userId": userId,
        "postId": postId,
      },
    );
    final data = response.data["comment"];
    if (data == null) throw Exception("comment not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllComments() async {
    final response = await dio.post('http://10.0.2.2:8050/comments/');
    final data = response.data["comments"];
    if (data == null) throw Exception("comments not found in response");
    return data;
  }

  @override
  getCommentById(String id) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/comments/getCommentById',
      data: {"id": id},
    );
    final data = response.data["comment"];
    if (data == null) throw Exception("post not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllCommentsByUserId(String userId) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/comments/getAllCommentsByUserId',
      data: {"userId": userId},
    );
    final data = response.data["comments"];
    if (data == null) throw Exception("comments not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllCommentsByPostId(
    String postId,
    String userId,
  ) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/comments/getAllCommentsByPostId',
      data: {"postId": postId, "userId": userId},
    );
    final data = response.data["comments"];
    if (data == null) throw Exception("comments not found in response");
    return data;
  }
}
