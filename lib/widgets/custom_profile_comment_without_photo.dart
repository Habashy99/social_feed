import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomProfileCommentWithoutPhoto extends HookWidget {
  final String commentText;
  const CustomProfileCommentWithoutPhoto({
    required this.commentText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Text(commentText, style: TextStyle(fontSize: 18)),
    );
  }
}
