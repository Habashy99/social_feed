import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/providers/post_providers.dart';
import 'package:social_feed/helpers/providers/user_providers.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/post.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/widgets/custom_profile_comment_with_photo.dart';
import 'package:social_feed/widgets/custom_profile_comment_without_photo.dart';
import 'package:social_feed/widgets/custom_profile.dart';

class Profile extends HookConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final user = userBox.get('user');
    if (user == null) {
      return const Login();
    }
    final storedUser = ref.watch(userProvider(user.id));
    AsyncValue<List<PostModel>?> posts = ref.watch(
      postsProviderByUserId(user.id),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        title: Text('Profile', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            storedUser.when(
              data: (userData) {
                if (userData != null) {
                  return CustomProfile(
                    profilePhoto: userData.imageUrl,
                    profileName: userData.name,
                    profileEmail: userData.email,
                    userId: userData.id,
                  );
                } else {
                  return const Text("User not found");
                }
              },
              error: (err, stack) => Text('Error: $err'),
              loading: () => const CircularProgressIndicator(),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 8),
            posts.when(
              data: (postsList) {
                if (postsList == null || postsList.isEmpty) {
                  return const Text("No posts yet");
                }
                return Column(
                  children: [
                    ...postsList.map((post) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (post.imageUrl.isNotEmpty)
                              ? CustomProfileCommentWithPhoto(
                                commentOwner: post.userName,
                                commentText: post.text,
                                commentPhoto: post.imageUrl,
                                numOfComments: post.totalComments,
                                numOfFavorites: post.totalFavorites,
                                doesLoggedUserMarkItAsFavorite: post.isFavorite,
                              )
                              : CustomProfileCommentWithoutPhoto(
                                commentOwner: post.userName,
                                commentText: post.text,
                                numOfComments: post.totalComments,
                                numOfFavorites: post.totalFavorites,
                                doesLoggedUserMarkItAsFavorite: post.isFavorite,
                              ),
                          SizedBox(height: 8),
                          Divider(color: Colors.grey, thickness: 1),
                          SizedBox(height: 8),
                        ],
                      );
                    }),
                  ],
                );
              },
              error: (err, stack) => Text('Error: $err'),
              loading: () => const CircularProgressIndicator(),
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 1),
          ],
        ),
      ),
    );
  }
}
