import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/post.dart';
import 'package:social_feed/models/post.dart';

final postProvider = FutureProvider.autoDispose
    .family<PostModel?, ({String id, String userId})>((ref, args) async {
      final postsController = ref.watch(postControllerProvider);
      final post = await postsController.getPostById(args.id, args.userId);
      return post;
    });

final postsProvider = FutureProvider.autoDispose
    .family<List<PostModel>, String>((ref, userId) async {
      final postsController = ref.watch(postControllerProvider);
      final posts = await postsController.getAllPosts(userId);
      return posts;
    });

final postsProviderByUserId = FutureProvider.autoDispose
    .family<List<PostModel>, String>((ref, userId) async {
      final postsController = ref.watch(postControllerProvider);
      final posts = await postsController.getAllPostsByUserId(userId);
      return posts;
    });

final createPostProvider = FutureProvider.autoDispose
    .family<PostModel?, ({String text, String? imageUrl, String userId})>((
      ref,
      args,
    ) async {
      final postsController = ref.watch(postControllerProvider);
      final post = await postsController.createPost(
        args.text,
        args.imageUrl,
        args.userId,
      );
      return post;
    });
