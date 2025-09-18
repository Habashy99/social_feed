import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/providers/comment_providers.dart';
import 'package:social_feed/helpers/providers/post_providers.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/comment.dart';
import 'package:social_feed/models/post.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/widgets/comment_with_photo.dart';
import 'package:social_feed/widgets/comment_without_photo.dart';
import 'package:social_feed/widgets/image_input.dart';
import 'package:social_feed/widgets/text_field_add_comment.dart';

class Comments extends HookConsumerWidget {
  final String postId;
  const Comments({required this.postId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final loggedInUser = userBox.get('user');
    if (loggedInUser == null) {
      return const Login();
    }
    final selectedImage = useState<File?>(null);
    final commentController = useTextEditingController();
    AsyncValue<PostModel?> post = ref.watch(
      postProvider((id: postId, userId: loggedInUser.id)),
    );
    AsyncValue<List<CommentModel>?> comments = ref.watch(
      commentsProviderByPostId((postId: postId, userId: loggedInUser.id)),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        title: Text('Comments', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            post.when(
              loading: () => const CircularProgressIndicator(),
              error: (err, stack) => Text('Error: $err'),
              data: (post) {
                if (post == null) {
                  return Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }
                return Column(
                  children: [
                    SizedBox(height: 16),
                    post.imageUrl != ""
                        ? CommentWithPhoto(
                          profileImage: post.userImageUrl,
                          profileName: post.userName,
                          commentText: post.text,
                          createdAt: post.createdAt,
                          commentPhoto: post.imageUrl,
                          numOfFavorites: post.totalFavorites,
                          doesLoggedUserMarkItAsFavorite: post.isFavorite,
                        )
                        : CommentWithoutPhoto(
                          profilePhoto: post.userImageUrl,
                          profileName: post.userName,
                          commentText: post.text,
                          createdAt: post.createdAt,
                          numOfFavorites: post.totalFavorites,
                          doesLoggedUserMarkItAsFavorite: post.isFavorite,
                        ),
                    SizedBox(height: 8),
                    Divider(color: Colors.grey, thickness: 1),
                    SizedBox(height: 8),
                    comments.when(
                      data: (commentsList) {
                        if (commentsList == null || commentsList.isEmpty) {
                          return const Text("No comments yet");
                        }
                        return Column(
                          children:
                              commentsList.map((comment) {
                                return Column(
                                  children: [
                                    (comment.commentPhoto != null &&
                                            comment.commentPhoto!.isNotEmpty)
                                        ? CommentWithPhoto(
                                          profileImage: comment.userImageUrl,
                                          profileName: comment.userName,
                                          createdAt: comment.createdAt,
                                          commentText: comment.comment,
                                          commentPhoto: comment.commentPhoto!,
                                          numOfFavorites:
                                              comment.totalFavorites,
                                          doesLoggedUserMarkItAsFavorite:
                                              comment.isFavorite,
                                        )
                                        : CommentWithoutPhoto(
                                          profilePhoto: comment.userImageUrl,
                                          profileName: comment.userName,
                                          createdAt: comment.createdAt,
                                          commentText: comment.comment,
                                          numOfFavorites:
                                              comment.totalFavorites,
                                          doesLoggedUserMarkItAsFavorite:
                                              comment.isFavorite,
                                        ),
                                    const SizedBox(height: 8),
                                    const Divider(
                                      color: Colors.grey,
                                      thickness: 1,
                                    ),
                                    const SizedBox(height: 8),
                                  ],
                                );
                              }).toList(),
                        );
                      },
                      error: (err, stack) => Text('Error: $err'),
                      loading: () => const CircularProgressIndicator(),
                    ),
                    TextFieldAddComment(
                      controller: commentController,
                      onSubmit: () async {
                        final createdComment = await ref.read(
                          createCommentProvider((
                            comment: commentController.text,
                            commentPhoto: selectedImage.value?.path,
                            postId: post.id,
                            userId: loggedInUser.id,
                          )).future,
                        );

                        if (createdComment != null) {
                          commentController.clear();
                          selectedImage.value = null;
                          ref.invalidate(
                            commentsProviderByPostId((
                              postId: post.id,
                              userId: loggedInUser.id,
                            )),
                          );
                        }
                      },
                    ),
                    ImageInput(
                      selectedImage: selectedImage.value,
                      onSelectImage: (image) {
                        selectedImage.value = image;
                      },
                    ),
                    SizedBox(height: 32),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
