import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/post.dart';
import 'package:social_feed/widgets/image_input.dart';
import 'package:social_feed/widgets/name_with_image.dart';

class NewPost extends HookConsumerWidget {
  const NewPost({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final PostsController _postsController = PostsController(ref);
    final selectedImage = useState<File?>(null);
    final titleController = useTextEditingController(text: "");
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            child: Text(
              "Post",
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            onPressed: () async {
              _postsController.createPost(
                titleController.text,
                selectedImage.value?.path,
                "1",
              );
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
              profilePhoto: "assets/images/1.jpg",
              profileName: "Sarah Martin",
            ),
          ),
          SizedBox(height: 18),
          TextField(
            controller: titleController,
            maxLines: 10, // allow it to grow vertically with content
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              contentPadding: EdgeInsets.only(left: 16, right: 16),
            ),
          ),
          SizedBox(height: 16),
          ImageInput(
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
