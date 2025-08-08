import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NameWithImage extends HookWidget {
  final String profileName;
  final String profilePhoto;
  const NameWithImage({
    required this.profileName,
    required this.profilePhoto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.asset(
            profilePhoto,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 8),
        Text(
          profileName,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
