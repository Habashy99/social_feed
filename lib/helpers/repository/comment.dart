import 'package:social_feed/helpers/providers/comment_api.dart';
import 'package:social_feed/models/comment.dart';

class CommentRepository {
  final CommentsProvider _commentsProvider = CommentsProvider();
  final CommentsMapper _commentsMapper = CommentsMapper();
  Future<List<CommentModel>> fetchAllComments() async {
    final json = await _commentsProvider.getAllComments();
    if (json == null) {
      return [];
    }
    return json.map((json) => _commentsMapper.mapFromJson(json)).toList();
  }

  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    final json = await _commentsProvider.createComment(
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
