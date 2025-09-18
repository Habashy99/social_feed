import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/riverpod/posts.dart';
import 'package:social_feed/models/post.dart';

abstract interface class IPosts {
  Future<PostModel?> createPost(String title, String? imageUrl, String userId);
  Future<List<PostModel>> getAllPosts(String userId);
  Future<PostModel?> getPostById(String id, String userId);
  Future<List<PostModel>> getAllPostsByUserId(String userId);
}

final postControllerProvider = Provider.autoDispose<PostsController>(
  (ref) =>
      PostsController(postsNotifier: ref.watch(postsStateProvider.notifier)),
);

class PostsController implements IPosts {
  final PostsNotifier _postNotifier;

  PostsController({required PostsNotifier postsNotifier})
    : _postNotifier = postsNotifier;

  @override
  Future<PostModel?> createPost(
    String text,
    String? imageUrl,
    String userId,
  ) async {
    return _postNotifier.createPost(text, imageUrl ?? "", userId);
  }

  @override
  Future<List<PostModel>> getAllPosts(String userId) async {
    return _postNotifier.fetchAllPosts(userId);
  }

  @override
  Future<PostModel?> getPostById(String id, String userId) async {
    return _postNotifier.fetchPostById(id, userId);
  }

  @override
  Future<List<PostModel>> getAllPostsByUserId(String userId) async {
    return _postNotifier.fetchAllPostsByUserId(userId);
  }
}
