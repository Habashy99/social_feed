import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class PostWithoutPhoto extends HookWidget {
  final String profilePhoto;
  final String profileName;
  final String createdAt;
  final String commentText;
  final String numOfComments;
  final String numOfFavorites;
  final bool doesLoggedUserMarkItAsFavorite;

  const PostWithoutPhoto({
    required this.profilePhoto,
    required this.profileName,
    required this.createdAt,
    required this.commentText,
    required this.numOfComments,
    required this.numOfFavorites,
    required this.doesLoggedUserMarkItAsFavorite,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child:
                    profilePhoto.startsWith("assets/")
                        ? Image.asset(
                          profilePhoto,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        )
                        : Image.file(
                          File(profilePhoto),
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
          SizedBox(height: 8),
          Row(
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(
                      doesLoggedUserMarkItAsFavorite
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: doesLoggedUserMarkItAsFavorite ? Colors.red : null,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(numOfFavorites),
                ],
              ),
              SizedBox(width: 16),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: Icon(Icons.chat_bubble_outline_outlined, size: 20),
                  ),
                  SizedBox(width: 5),
                  Text(numOfComments),
                ],
              ),
              SizedBox(width: 16),
              Text("Add a comment... "),
            ],
          ),
        ],
      ),
    );
  }
}
