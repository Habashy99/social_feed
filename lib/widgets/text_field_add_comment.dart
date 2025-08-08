import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class TextFieldAddComment extends HookWidget {
  final TextEditingController controller;
  final Future<void> Function() onSubmit;
  const TextFieldAddComment({
    required this.controller,
    required this.onSubmit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Add a comment",
        hintStyle: TextStyle(fontSize: 16),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Icon(Icons.chat_bubble, size: 20),
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ), // Tighter layout
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
      ),
      onSubmitted: (value) {
        if (value.isNotEmpty) {
          onSubmit();
          controller.clear();
        }
      },
    );
  }
}
