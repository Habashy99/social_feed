import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CommentWithPhoto extends HookWidget {
  final String profileImage;
  final String profileName;
  final String createdAt;
  final String commentText;
  final String commentPhoto;
  const CommentWithPhoto({
    required this.profileImage,
    required this.profileName,
    required this.createdAt,
    required this.commentText,
    required this.commentPhoto,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  profileImage,
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
              Spacer(),
              Icon(CupertinoIcons.ellipsis),
            ],
          ),
          Column(
            children: [
              Text(commentText, style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.asset(commentPhoto, fit: BoxFit.cover),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              InkWell(
                onTap: () {},
                child: Icon(Icons.chat_bubble_outline_outlined, size: 20),
              ),
              SizedBox(width: 4),
              Text("Add a comment... "),
            ],
          ),
        ],
      ),
    );
  }
}
