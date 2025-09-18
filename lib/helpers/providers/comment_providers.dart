import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/comment.dart';
import 'package:social_feed/models/comment.dart';

final commentProvider = FutureProvider.autoDispose
    .family<CommentModel?, String>((ref, id) async {
      final commentsController = ref.watch(commentsControllerProvider);
      final comment = await commentsController.getCommentById(id);
      return comment;
    });
final commentsProvider = FutureProvider.autoDispose<List<CommentModel>>((
  ref,
) async {
  final commentsController = ref.watch(commentsControllerProvider);
  final comments = await commentsController.getAllComments();
  return comments;
});
final commentsProviderByUserId = FutureProvider.autoDispose
    .family<List<CommentModel>, String>((ref, userId) async {
      final commentsController = ref.watch(commentsControllerProvider);
      final comments = await commentsController.getAllCommentsByUserId(userId);
      return comments;
    });
final commentsProviderByPostId = FutureProvider.autoDispose
    .family<List<CommentModel>, ({String userId, String postId})>((
      ref,
      args,
    ) async {
      final commentsController = ref.watch(commentsControllerProvider);
      final comments = await commentsController.getAllCommentsByPostId(
        args.postId,
        args.userId,
      );
      return comments;
    });

final createCommentProvider = FutureProvider.autoDispose.family<
  CommentModel?,
  ({String comment, String? commentPhoto, String userId, String postId})
>((ref, args) async {
  final commentsController = ref.watch(commentsControllerProvider);
  final comment = await commentsController.createComment(
    args.comment,
    args.commentPhoto,
    args.userId,
    args.postId,
  );
  return comment;
});
