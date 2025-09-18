import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomProfileCommentWithPhoto extends HookWidget {
  final String commentOwner;
  final String commentText;
  final String commentPhoto;
  final String numOfComments;
  final String numOfFavorites;
  final bool doesLoggedUserMarkItAsFavorite;
  const CustomProfileCommentWithPhoto({
    required this.commentOwner,
    required this.commentText,
    required this.commentPhoto,
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
          Text(
            commentOwner,
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(commentText, style: TextStyle(fontSize: 18)),
          SizedBox(height: 8),

          ClipRRect(
            borderRadius: BorderRadius.circular(5),

            child:
                commentPhoto.startsWith("assets/")
                    ? Image.asset(commentPhoto, fit: BoxFit.cover)
                    : Image.file(File(commentPhoto), fit: BoxFit.cover),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(
                        doesLoggedUserMarkItAsFavorite
                            ? Icons.favorite
                            : Icons.favorite_border_outlined,
                        color:
                            doesLoggedUserMarkItAsFavorite ? Colors.red : null,
                        size: 20,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(numOfFavorites),
                  ],
                ),
              ),
              SizedBox(width: 18),
              SizedBox(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Icon(Icons.chat_bubble_outline, size: 20),
                    ),
                    SizedBox(width: 5),
                    Text(numOfComments),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
