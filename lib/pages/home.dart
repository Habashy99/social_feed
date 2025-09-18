import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/providers/auth_providers.dart';
import 'package:social_feed/helpers/providers/post_providers.dart';
import 'package:social_feed/helpers/providers/user_providers.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/comments.dart';
import 'package:social_feed/pages/image_preview.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/pages/new_post.dart';
import 'package:social_feed/pages/profile.dart';
import 'package:social_feed/widgets/custom_button.dart';
import 'package:social_feed/widgets/post_with_photo.dart';
import 'package:social_feed/widgets/post_without_photo.dart';
import 'package:social_feed/widgets/story_icon.dart';
import 'package:social_feed/widgets/story_widget.dart';

class Home extends HookConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final user = userBox.get('user');
    if (user == null) {
      return Login();
    }
    final posts = ref.watch(postsProvider(user.id));
    final users = ref.watch(usersProvider);
    useEffect(() {
      Future.microtask(() {
        ref.invalidate(usersProvider);
        ref.invalidate(postsProvider(user.id));
      });
      return null;
    }, []);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 80,
        leading: Padding(
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 24, right: 8),
          child: InkWell(
            child: ClipOval(
              child:
                  user.imageUrl.startsWith("assets/")
                      ? Image.asset(
                        user.imageUrl,
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      )
                      : Image.file(
                        File(user.imageUrl),
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
            ),
            onTap: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => Profile()));
            },
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        title: Text('Social Feed App', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () async {
                // 1. Clear user from Hive
                await ref.read(logoutProvider.future);
                // 3. Navigate to login page
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => Login()),
                  (route) => false,
                );
              },
              icon: Icon(Icons.notifications_none),
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            users.when(
              data:
                  (usersList) => SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const StoryWidget(),
                          const SizedBox(width: 12),
                          ...usersList
                              .where(
                                (loggedInUser) => loggedInUser.id != user.id,
                              )
                              .map((user) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: InkWell(
                                    child: StoryIcon(
                                      image: user.imageUrl,
                                      name: user.name,
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ImagePreview(
                                                image: user.imageUrl,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Text("Error loading users: $e"),
            ),
            Divider(),
            SizedBox(height: 14),
            posts.when(
              data: (postList) {
                if (postList.isEmpty) {
                  return const Center(child: Text("No posts yet"));
                }
                postList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: postList.length,
                  itemBuilder: (context, index) {
                    final post = postList[index];
                    return GestureDetector(
                      child:
                          (post.imageUrl.isNotEmpty)
                              ? PostWithPhoto(
                                commentPhoto: post.imageUrl,
                                commentText: post.text,
                                createdAt: post.createdAt,
                                profileImage: post.userImageUrl,
                                profileName: post.userName,
                                numOfComments: post.totalComments,
                                numOfFavorites: post.totalFavorites,
                                doesLoggedUserMarkItAsFavorite: post.isFavorite,
                              )
                              : PostWithoutPhoto(
                                profilePhoto: post.userImageUrl,
                                profileName: post.userName,
                                createdAt: post.createdAt,
                                commentText: post.text,
                                numOfComments: post.totalComments,
                                numOfFavorites: post.totalFavorites,
                                doesLoggedUserMarkItAsFavorite: post.isFavorite,
                              ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Comments(postId: post.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Text("Error loading posts: $error"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 60,
              child: CustomButton(
                text: "Create Post",
                onPress: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => NewPost()));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
