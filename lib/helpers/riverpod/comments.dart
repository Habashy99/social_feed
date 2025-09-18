import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/repository/comment.dart';
import 'package:social_feed/models/comment.dart';

final commentsRepository = Provider<CommentRepository>(
  (ref) => CommentRepository(),
);
final commentsStateProvider =
    StateNotifierProvider<CommentsNotifier, AsyncValue<List<CommentModel>>>(
      (ref) => CommentsNotifier(ref.read(commentsRepository)),
    );

class CommentsNotifier extends StateNotifier<AsyncValue<List<CommentModel>>> {
  final CommentRepository commentsRepository;
  CommentsNotifier(this.commentsRepository) : super(const AsyncValue.loading());
  Future<CommentModel?> createComment(
    String comment,
    String? commentPhoto,
    String userId,
    String postId,
  ) async {
    try {
      final createdComment = await commentsRepository.createComment(
        comment,
        commentPhoto,
        userId,
        postId,
      );
      if (createdComment != null) {
        _updateState(newState: AsyncValue.data([createdComment]));
      }
      return createdComment;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    return null;
  }

  Future<CommentModel?> fetchCommentById(String id) async {
    try {
      final comment = await commentsRepository.fetchCommentById(id);
      if (comment != null) {
        _updateState(newState: AsyncValue.data([comment]));
        return comment;
      } else {
        return null;
      }
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    throw Exception("post not found");
  }

  Future<List<CommentModel>> fetchAllComments() async {
    try {
      final comments = await commentsRepository.fetchAllComments();
      _updateState(newState: AsyncValue.data(comments));
      return comments;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    return [];
  }

  Future<List<CommentModel>> fetchAllCommentsByUserId(String userId) async {
    try {
      final comments = await commentsRepository.fetchAllCommentsByUserId(
        userId,
      );
      _updateState(newState: AsyncValue.data(comments));
      return comments;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    return [];
  }

  Future<List<CommentModel>> fetchAllCommentsByPostId(
    String postId,
    String userId,
  ) async {
    try {
      final comments = await commentsRepository.fetchAllCommentsByPostId(
        postId,
        userId,
      );
      _updateState(newState: AsyncValue.data(comments));
      return comments;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    return [];
  }

  void _updateState({required AsyncValue<List<CommentModel>> newState}) {
    if (mounted) {
      state = newState;
    }
  }
}
