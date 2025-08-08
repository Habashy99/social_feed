import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/auth.dart';
import 'package:social_feed/helpers/controllers/comment.dart';
import 'package:social_feed/helpers/controllers/post.dart';
import 'package:social_feed/models/post.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/widgets/comment_with_photo.dart';
import 'package:social_feed/widgets/comment_without_photo.dart';
import 'package:social_feed/widgets/text_field_add_comment.dart';

class Comments extends HookConsumerWidget {
  final String postId;
  const Comments({required this.postId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();
    CommentsController commentsController = CommentsController(ref);
    final AuthController authController = AuthController(ref);
    PostsController postsController = PostsController(ref);
    final post = useState<List<PostModel?>>([]);
    final user = useState<HiveUserModel?>(null);
    final isLoading = useState(true);
    useEffect(() {
      Future.microtask(() async {
        final postData = await postsController.getAllPosts();
        if (postData != null) {
          post.value = postData;
          isLoading.value = false;
        }
      });
      Future.microtask(() async {
        final userData = await authController.getUserById("1");
        if (userData != null) {
          user.value = userData;
        }
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        centerTitle: true,
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
        elevation: 4,
      ),
      body:
          isLoading.value
              ? Center(child: Text("Error to fetch the selected blog"))
              : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    CommentWithPhoto(
                      profileImage: "assets/images/1.jpg",
                      profileName: user.value?.name ?? "",
                      commentText:
                          'Lorem ipsum dolor sit amet, consectetur adipiscing',
                      createdAt: "2h ago",
                      commentPhoto:
                          post.value[0]?.imageUrl ?? "assets/images/coast.png",
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: CommentWithoutPhoto(
                        profilePhoto: "assets/images/2.jpg",
                        profileName: "John",
                        createdAt: "1h ago",
                        commentText:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing',
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      child: CommentWithoutPhoto(
                        profilePhoto: "assets/images/3.jpeg",
                        profileName: "Emma",
                        createdAt: "10h ago",
                        commentText:
                            'Lorem ipsum dolor sit amet, consectetur adipiscing',
                      ),
                    ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 8),
                    TextFieldAddComment(
                      controller: commentController,
                      onSubmit: () async {
                        commentsController.createComment(
                          commentController.text,
                          "commentPhoto",
                          "1",
                          "1",
                        );
                      },
                    ),
                    SizedBox(height: 32),
                  ],
                ),
              ),
    );
  }
}
