import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_feed/widgets/custom_image.dart';

class ImageInput extends HookWidget {
  final void Function(File? image) onSelectImage;
  final File? selectedImage;
  final String? initialImageUrl;

  const ImageInput({
    super.key,
    required this.onSelectImage,
    this.selectedImage,
    this.initialImageUrl,
  });

  takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) return;
    onSelectImage(File(pickedImage.path));
  }

  @override
  Widget build(BuildContext context) {
    final imageToShow =
        selectedImage != null
            ? CustomImage(path: selectedImage!.path)
            : (initialImageUrl != null && initialImageUrl!.isNotEmpty
                ? CustomImage(path: initialImageUrl!)
                : null);
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Color.fromARGB(255, 0, 48, 87)),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child:
          imageToShow == null
              ? TextButton.icon(
                onPressed: takePicture,
                label: Text("Take Picture"),
                icon: Icon(Icons.camera),
              )
              : Stack(
                children: [
                  GestureDetector(onTap: takePicture, child: imageToShow),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => onSelectImage(null),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }
}
