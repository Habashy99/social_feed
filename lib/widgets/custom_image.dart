import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomImage extends HookWidget {
  final String path;
  const CustomImage({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    if (path.startsWith("http")) {
      // network image
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (path.startsWith("assets/")) {
      // asset image
      return Image.asset(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      // assume local file
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }
}
