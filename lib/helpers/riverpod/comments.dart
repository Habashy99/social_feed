import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/repository/comment.dart';
import 'package:social_feed/models/comment.dart';

final commentsRepository = Provider((ref) => CommentRepository());
final commentsStateProvider = StateNotifierProvider(
  (ref) => CommentsNotifier(ref),
);

abstract class CommentState {}

class SinglePost extends CommentState {
  final CommentModel comment;
  SinglePost(this.comment);
}

class PostList extends CommentState {
  final List<CommentModel> comments;
  PostList(this.comments);
}

class CommentsNotifier extends StateNotifier<AsyncValue<CommentState?>> {
  final Ref ref;
  CommentsNotifier(this.ref) : super(const AsyncValue.data(null));
  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    state = const AsyncValue.loading();
    try {
      final createdComment = await ref
          .read(commentsRepository)
          .createComment(comment, commentPhoto, userId, postId);
      state = AsyncValue.data(SinglePost(createdComment!));
      return createdComment;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
    return null;
  }

  Future<List<CommentModel>> fetchAllComments() async {
    state = const AsyncValue.loading();
    try {
      final comments = await ref.read(commentsRepository).fetchAllComments();
      state = AsyncValue.data(PostList(comments ?? []));
      return comments;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
    return [];
  }
}
