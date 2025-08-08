import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends HookWidget {
  final void Function(File? image) onSelectImage;
  ImageInput({super.key, required this.onSelectImage});
  final _selectedImage = useState<File?>(null);
  _takePicture() async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    if (pickedImage == null) {
      return;
    }

    _selectedImage.value = File(pickedImage.path);
    onSelectImage(_selectedImage.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: const Color.fromARGB(255, 0, 48, 87),
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child:
          _selectedImage.value == null
              ? TextButton.icon(
                onPressed: _takePicture,
                label: Text("Take Picture"),
                icon: Icon(Icons.camera),
              )
              : GestureDetector(
                onTap: _takePicture,
                child: Image.file(
                  _selectedImage.value!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
    );
  }
}
