import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/riverpod/posts.dart';
import 'package:social_feed/models/post.dart';

abstract interface class IPosts {
  Future<PostModel?> createPost(String title, String? imageUrl, String userId);
  Future<List<PostModel>?> getAllPosts();
  Future<PostModel?> getPostById(String id);
}

class PostsController implements IPosts {
  final WidgetRef ref;
  PostsController(this.ref);
  @override
  Future<PostModel?> createPost(
    String title,
    String? imageUrl,
    String userId,
  ) async {
    try {
      final image = imageUrl ?? "";
      return await ref
          .read(postsStateProvider.notifier)
          .createPost(title, image, userId);
    } catch (error) {
      print(error);
    }
    return null;
  }

  @override
  Future<List<PostModel>?> getAllPosts() async {
    try {
      return await ref.read(postsStateProvider.notifier).fetchAllPosts();
    } catch (error) {
      print(error);
    }
    return [];
  }

  @override
  Future<PostModel?> getPostById(String id) async {
    try {
      final post = await ref
          .read(postsStateProvider.notifier)
          .fetchPostById(id);
      return post;
    } catch (error) {
      print(error);
    }
    return null;
  }
}
