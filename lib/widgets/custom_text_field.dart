import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextField extends HookWidget {
  final String text;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool isObscured;

  const CustomTextField({
    this.suffixIcon,
    required this.controller,
    required this.text,
    required this.validator,
    super.key,
    this.keyboardType,
    this.isObscured = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 0, 48, 87),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: isObscured,
        controller: controller,
        validator: validator,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: text,
          labelStyle: TextStyle(color: Colors.white),
          hintText: text,
          hintStyle: TextStyle(color: Colors.white),
          border: InputBorder.none,
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
