import 'package:social_feed/helpers/apis/post_api.dart';
import 'package:social_feed/models/post.dart';

class PostRepository {
  final PostsApis _postsApis = PostsApis();
  final PostMapper _postMapper = PostMapper();
  Future<List<PostModel>> fetchAllPosts(String userId) async {
    final json = await _postsApis.getAllPosts(userId);
    final posts = json.map((json) => _postMapper.mapFromJson(json)).toList();
    return posts;
  }

  Future<List<PostModel>> fetchAllPostsByUserId(String userId) async {
    final json = await _postsApis.getAllPostsByUserId(userId);
    final posts = json.map((json) => _postMapper.mapFromJson(json)).toList();
    return posts;
  }

  Future<PostModel?> createPost(
    String text,
    String? imageUrl,
    String userId,
  ) async {
    final json = await _postsApis.createPost(text, imageUrl, userId);
    if (json == null) {
      return null;
    }
    return _postMapper.mapFromJson(json);
  }

  Future<PostModel?> fetchPostById(String id, String userId) async {
    final json = await _postsApis.getPostById(id, userId);
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
