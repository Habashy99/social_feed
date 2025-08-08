import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommentWithoutPhoto extends HookWidget {
  final String profilePhoto;
  final String profileName;
  final String createdAt;
  final String commentText;

  const CommentWithoutPhoto({
    required this.profilePhoto,
    required this.profileName,
    required this.createdAt,
    required this.commentText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profileName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  createdAt,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
        Text(commentText, style: TextStyle(fontSize: 18)),
      ],
    );
  }
}
