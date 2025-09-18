import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/providers/post_providers.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/home.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/widgets/image_input.dart';
import 'package:social_feed/widgets/name_with_image.dart';

class NewPost extends HookConsumerWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImage = useState<File?>(null);
    final textController = useTextEditingController(text: "");
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final user = userBox.get('user');
    if (user == null) {
      return const Login();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 48, 87),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: <Widget>[
          TextButton(
            child: Text(
              "Post",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: () async {
              final post = await ref.watch(
                createPostProvider((
                  text: textController.text,
                  imageUrl: selectedImage.value?.path ?? "",
                  userId: user.id,
                )).future,
              );
              if (post != null) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => true,
                );
              }
            },
          ),
        ],
        shape: const Border(bottom: BorderSide(color: Colors.grey, width: 1.5)),
        elevation: 4,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: NameWithImage(
              profilePhoto: user.imageUrl,
              profileName: user.name,
            ),
          ),
          SizedBox(height: 18),
          TextField(
            controller: textController,
            maxLines: 10, // allow it to grow vertically with content
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.only(left: 16, right: 16),
            ),
          ),
          SizedBox(height: 16),
          ImageInput(
            selectedImage: selectedImage.value,
            onSelectImage: (image) {
              selectedImage.value = image;
            },
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}
