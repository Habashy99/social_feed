import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/riverpod/comments.dart';
import 'package:social_feed/models/comment.dart';

abstract interface class IComments {
  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  );
  Future<List<CommentModel>> getAllComments();
  Future<CommentModel?> getCommentById(String id);
  Future<List<CommentModel>> getAllCommentsByUserId(String userId);
  Future<List<CommentModel>> getAllCommentsByPostId(
    String postId,
    String userId,
  );
}

final commentsControllerProvider = Provider.autoDispose(
  (ref) => CommentsController(
    commentsNotifier: ref.watch(commentsStateProvider.notifier),
  ),
);

class CommentsController implements IComments {
  final CommentsNotifier _commentsNotifier;
  CommentsController({required CommentsNotifier commentsNotifier})
    : _commentsNotifier = commentsNotifier;
  @override
  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    try {
      final image = commentPhoto ?? "";
      return await _commentsNotifier.createComment(
        comment,
        image,
        userId,
        postId,
      );
    } catch (error) {
      print(error);
    }
    return null;
  }

  @override
  Future<List<CommentModel>> getAllComments() async {
    try {
      return await _commentsNotifier.fetchAllComments();
    } catch (error) {
      print(error);
    }
    return [];
  }

  @override
  Future<CommentModel?> getCommentById(String id) async {
    return _commentsNotifier.fetchCommentById(id);
  }

  @override
  Future<List<CommentModel>> getAllCommentsByUserId(String userId) async {
    return _commentsNotifier.fetchAllCommentsByUserId(userId);
  }

  @override
  Future<List<CommentModel>> getAllCommentsByPostId(
    String postId,
    String userId,
  ) async {
    return _commentsNotifier.fetchAllCommentsByPostId(postId, userId);
  }
}
