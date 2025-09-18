import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ImagePreview extends HookWidget {
  final String image;

  const ImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    // useEffect ensures cleanup
    useEffect(() {
      final timer = Timer(const Duration(seconds: 5), () {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      });

      return timer.cancel;
    }, []);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child:
            image.startsWith("assets/")
                ? Image.asset(image, fit: BoxFit.cover)
                : Image.file(File(image), fit: BoxFit.cover),
      ),
    );
  }
}
