import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/user.dart';
import 'package:social_feed/helpers/providers/user_providers.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/models/user.dart';
import 'package:social_feed/pages/login.dart';
import 'package:social_feed/widgets/custom_button.dart';
import 'package:social_feed/widgets/custom_text_field.dart';
import 'package:social_feed/widgets/image_input.dart';

class EditProfile extends HookConsumerWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final user = userBox.get('user');
    if (user == null) {
      return const Login();
    }
    AsyncValue<HiveUserModel?> storedUser = ref.watch(userProvider(user.id));
    return storedUser.when(
      data: (storedUser) {
        final userNameController = useTextEditingController(
          text: storedUser?.name ?? "",
        );
        final selectedImage = useState<File?>(
          storedUser?.imageUrl != null && storedUser!.imageUrl.isNotEmpty
              ? File(storedUser.imageUrl) // convert path string to File
              : null,
        );

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 48, 87),
            title: const Text(
              'Edit Profile',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                const SizedBox(height: 24),
                CustomTextField(
                  text: "userName",
                  controller: userNameController,
                  validator:
                      (value) => value!.isEmpty ? "Missing userName" : null,
                ),
                const SizedBox(height: 24),
                ImageInput(
                  selectedImage: selectedImage.value,
                  initialImageUrl:
                      storedUser?.imageUrl, // 👈 pass old image URL
                  onSelectImage: (image) {
                    selectedImage.value = image;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Edit Profile",
                  onPress: () async {
                    final updatedUser = await ref.read(
                      editUserProvider((
                        id: user.id,
                        name: userNameController.text,
                        imageUrl:
                            selectedImage.value != null
                                ? selectedImage.value!.path
                                : storedUser?.imageUrl ?? "",
                      )).future,
                    );
                    if (updatedUser != null) {
                      // Save new data to Hive
                      final userBox = HiveService.getBox<HiveUserModel>(
                        'userbox',
                      );
                      await userBox.put('user', updatedUser);

                      // Pop and refresh Profile
                      Navigator.of(context).pop(true);
                    }
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stackTrace) =>
              Scaffold(body: Center(child: Text("Error: $error"))),
    );
  }
}
