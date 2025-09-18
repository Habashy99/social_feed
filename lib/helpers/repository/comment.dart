import 'package:social_feed/helpers/apis/comment_api.dart';
import 'package:social_feed/models/comment.dart';

class CommentRepository {
  final CommentsApis _commentsApis = CommentsApis();
  final CommentsMapper _commentsMapper = CommentsMapper();
  Future<List<CommentModel>> fetchAllComments() async {
    final json = await _commentsApis.getAllComments();
    final data = json.map((json) => _commentsMapper.mapFromJson(json)).toList();
    return data;
  }

  Future<List<CommentModel>> fetchAllCommentsByUserId(String userId) async {
    final json = await _commentsApis.getAllCommentsByUserId(userId);
    final data = json.map((json) => _commentsMapper.mapFromJson(json)).toList();
    return data;
  }

  Future<List<CommentModel>> fetchAllCommentsByPostId(
    String postId,
    String userId,
  ) async {
    final json = await _commentsApis.getAllCommentsByPostId(postId, userId);
    final data = json.map((json) => _commentsMapper.mapFromJson(json)).toList();
    return data;
  }

  Future<CommentModel?> fetchCommentById(String id) async {
    final json = await _commentsApis.getCommentById(id);
    if (json == null) {
      return null;
    }
    final data = _commentsMapper.mapFromJson(json);
    return data;
  }

  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    final json = await _commentsApis.createComment(
      comment,
      commentPhoto,
      userId,
      postId,
    );
    if (json == null) {
      return null;
    }
    return _commentsMapper.mapFromJson(json);
  }
}

abstract interface class ICommentsMapper {
  CommentModel mapFromJson(Map<String, dynamic> json);
}

class CommentsMapper extends ICommentsMapper {
  @override
  CommentModel mapFromJson(Map<String, dynamic> json) {
    return CommentModel.fromJson(json);
  }
}
