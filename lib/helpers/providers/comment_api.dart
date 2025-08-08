import 'package:dio/dio.dart';

abstract interface class IComments {
  createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  );
  getAllComments();
}

class CommentsProvider implements IComments {
  @override
  createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    final dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8050/comments/add',
      data: {
        "comment": comment,
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
    final dio = Dio();
    final response = await dio.get('http://10.0.2.2:8050/comments/');
    final data = response.data["comments"];
    if (data == null) throw Exception("comments not found in response");
    return data;
  }
}
