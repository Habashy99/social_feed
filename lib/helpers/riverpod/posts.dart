import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/repository/post_repo.dart';
import 'package:social_feed/models/post.dart';

final postsRepository = Provider<PostRepository>((ref) => PostRepository());
final postsStateProvider =
    StateNotifierProvider<PostsNotifier, AsyncValue<List<PostModel>>>(
      (ref) => PostsNotifier(ref.read(postsRepository)),
    );

class PostsNotifier extends StateNotifier<AsyncValue<List<PostModel>>> {
  final PostRepository postsRepository;
  PostsNotifier(this.postsRepository) : super(const AsyncValue.loading());

  Future<PostModel> createPost(
    String text,
    String? imageUrl,
    String userId,
  ) async {
    try {
      final post = await postsRepository.createPost(text, imageUrl, userId);
      if (post != null) {
        final currentPosts = state.value ?? [];
        _updateState(newState: AsyncValue.data([post, ...currentPosts]));
        return post;
      }
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    throw Exception("create post failed");
  }

  Future<List<PostModel>> fetchAllPosts(String userId) async {
    try {
      final posts = await postsRepository.fetchAllPosts(userId);
      _updateState(newState: AsyncValue.data(posts));
      return posts;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
      return [];
    }
  }

  Future<List<PostModel>> fetchAllPostsByUserId(String userId) async {
    try {
      final posts = await postsRepository.fetchAllPostsByUserId(userId);
      _updateState(newState: AsyncValue.data(posts));
      return posts;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
      return [];
    }
  }

  Future<PostModel?> fetchPostById(String id, String userId) async {
    try {
      final post = await postsRepository.fetchPostById(id, userId);
      if (post != null) {
        _updateState(newState: AsyncValue.data([post]));
        return post;
      } else {
        return null;
      }
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    throw Exception("post not found");
  }

  void _updateState({required AsyncValue<List<PostModel>> newState}) {
    if (mounted) {
      state = newState;
    }
  }
}
