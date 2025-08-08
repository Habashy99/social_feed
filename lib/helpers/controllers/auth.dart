import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/riverpod/auth.dart';
import 'package:social_feed/models/user.dart';

abstract interface class IAuth {
  void login(String email, String password);
  void signup(String name, String email, String password, File? image);
  Future<HiveUserModel?> getUserById(String id);
}

class AuthController implements IAuth {
  final WidgetRef ref;
  AuthController(this.ref);
  @override
  void login(String email, String password) {
    ref.read(authStateProvider.notifier).login(email, password);
  }

  @override
  void signup(String name, String email, String password, File? image) {
    final imagePath = image?.path ?? "";
    ref
        .read(authStateProvider.notifier)
        .signup(name, email, password, imagePath);
  }

  @override
  Future<HiveUserModel?> getUserById(String id) async {
    final user = await ref.read(authStateProvider.notifier).getUserById(id);
    return user;
  }
}
