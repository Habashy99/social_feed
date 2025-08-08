import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:social_feed/widgets/custom_profile_comment_with_photo.dart';
import 'package:social_feed/widgets/custom_profile_comment_without_photo.dart';
import 'package:social_feed/widgets/custom_profile.dart';

class Profile extends HookWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        title: Text('Sarfila', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            CustomProfile(
              profilePhoto: "assets/images/1.jpg",
              profileName: "Sarah Martin",
              profileEmail: "@sarah.martin",
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 8),
            CustomProfileCommentWithoutPhoto(
              commentText: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 1),
            SizedBox(height: 8),
            CustomProfileCommentWithPhoto(
              commentOwner: "Sarah Martin",
              commentText: 'Lorem ipsum dolor sit amet, consectetur adipiscing',
              commentPhoto: "assets/images/coast.png",
            ),
            SizedBox(height: 8),
            Divider(color: Colors.grey, thickness: 1),
          ],
        ),
      ),
    );
  }
}
