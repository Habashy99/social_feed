import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class StoryIcon extends HookWidget {
  final String image;
  final String name;
  const StoryIcon({required this.name, required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 60,
          child: ClipOval(
            child:
                image.startsWith("assets/")
                    ? Image.asset(
                      image,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                    : Image.file(
                      File(image),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
          ),
        ),
        Text(name),
      ],
    );
  }
}
