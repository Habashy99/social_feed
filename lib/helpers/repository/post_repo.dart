import 'package:social_feed/helpers/providers/post_api.dart';
import 'package:social_feed/models/post.dart';

class PostRepository {
  final PostsProvider _postsProvider = PostsProvider();
  final PostMapper _postMapper = PostMapper();
  Future<List<PostModel>> fetchAllPosts() async {
    final json = await _postsProvider.getAllPosts();
    if (json == null) {
      return [];
    }
    return json.map((json) => _postMapper.mapFromJson(json)).toList();
  }

  Future<PostModel?> createPost(
    String title,
    String? imageUrl,
    String userId,
  ) async {
    final json = await _postsProvider.createPost(title, imageUrl, userId);
    if (json == null) {
      return null;
    }
    return _postMapper.mapFromJson(json);
  }

  Future<PostModel?> fetchPostById(String id) async {
    final json = await _postsProvider.getPostById(id);
    if (json == null) {
      return null;
    }
    final data = _postMapper.mapFromJson(json);
    return data;
  }
}

abstract interface class IPostsMapper {
  PostModel mapFromJson(Map<String, dynamic> json);
}

class PostMapper extends IPostsMapper {
  @override
  PostModel mapFromJson(Map<String, dynamic> json) {
    return PostModel.fromJson(json);
  }
}
