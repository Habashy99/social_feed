import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/repository/post_repo.dart';
import 'package:social_feed/models/post.dart';

final postsRepository = Provider((ref) => PostRepository());
final postsStateProvider = StateNotifierProvider((ref) => PostsNotifier(ref));

abstract class PostState {}

class SinglePost extends PostState {
  final PostModel post;
  SinglePost(this.post);
}

class PostList extends PostState {
  final List<PostModel> posts;
  PostList(this.posts);
}

class PostsNotifier extends StateNotifier<AsyncValue<PostState?>> {
  final Ref ref;
  PostsNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<PostModel?> createPost(
    String title,
    String? imageUrl,
    String userId,
  ) async {
    state = const AsyncValue.loading();
    try {
      final post = await ref
          .read(postsRepository)
          .createPost(title, imageUrl, userId);
      state = AsyncValue.data(SinglePost(post!));
      return post;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
    return null;
  }

  Future<List<PostModel>?> fetchAllPosts() async {
    state = const AsyncValue.loading();
    try {
      final posts = await ref.read(postsRepository).fetchAllPosts();
      state = AsyncValue.data(PostList(posts ?? []));
      return posts;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
    return null;
  }

  Future<PostModel?> fetchPostById(String id) async {
    state = const AsyncValue.loading();
    try {
      final post = await ref.read(postsRepository).fetchPostById(id);
      if (post != null) {
        state = AsyncValue.data(SinglePost(post));
      } else {
        state = const AsyncValue.data(null);
      }
      return post;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
    return null;
  }
}
