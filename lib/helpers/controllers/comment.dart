import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/riverpod/comments.dart';
import 'package:social_feed/models/comment.dart';

abstract interface class IComments {
  void createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  );
  void getAllComments();
}

class CommentsController implements IComments {
  final WidgetRef ref;
  CommentsController(this.ref);
  @override
  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    try {
      final image = commentPhoto ?? "";
      return await ref
          .read(commentsStateProvider.notifier)
          .createComment(comment, image, userId, postId);
    } catch (error) {
      print(error);
    }
    return null;
  }

  @override
  Future<List<CommentModel>?> getAllComments() async {
    try {
      return await ref.read(commentsStateProvider.notifier).fetchAllComments();
    } catch (error) {
      print(error);
    }
    return [];
  }
}
