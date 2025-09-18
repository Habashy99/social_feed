import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed/helpers/providers/story_providers.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/widgets/story_icon.dart';
import 'package:social_feed/widgets/story_viewer.dart';

class StoryWidget extends HookConsumerWidget {
  const StoryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = ImagePicker();
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final user = userBox.get('user');

    final stories = ref.watch(storiesProvider);
    Future<void> pickStory(ImageSource source) async {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        await ref.read(
          addStoryProvider((
            userId: user!.id,
            image: File(pickedFile.path),
          )).future,
        );
        ref.invalidate(storiesProvider);
      }
    }

    void showAddOptions(List<String> storyPaths) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Take Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    pickStory(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Upload from Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    pickStory(ImageSource.gallery);
                  },
                ),
                if (storyPaths.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.visibility),
                    title: const Text("View My Story"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => StoryViewer(storyPaths: storyPaths),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      );
    }

    return stories.when(
      loading: () => StoryIcon(image: user?.imageUrl ?? "", name: "Your Story"),
      error:
          (err, st) => InkWell(
            onTap: () => showAddOptions([]),
            child: StoryIcon(image: user?.imageUrl ?? "", name: "Your Story"),
          ),
      data: (stories) {
        final storyPaths = stories.map((s) => s.imageUrl).toList();
        return InkWell(
          onTap: () => showAddOptions(storyPaths),
          child: StoryIcon(
            image:
                storyPaths.isNotEmpty
                    ? storyPaths.last
                    : (user?.imageUrl ?? ""),
            name: "Your Story",
          ),
        );
      },
    );
  }
}
