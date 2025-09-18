import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/riverpod/auth.dart';
import 'package:social_feed/models/user.dart';

abstract interface class IAuth {
  Future<HiveUserModel?> login(String email, String password);
  Future<HiveUserModel?> signup(
    String name,
    String email,
    String password,
    File? image,
  );
  Future<void> logout();
  Future<String> refreshAccessToken(String refreshToken, String userId);
  Future<void> checkAccessToken();
}

final authControllerProvider = Provider((ref) {
  final authController = AuthController(
    authNotifier: ref.watch(authStateProvider.notifier),
  );
  ref.onDispose(() {
    authController.dispose();
  });

  return authController;
});

class AuthController implements IAuth {
  final AuthNotifier _authNotifier;
  Timer? _timer;

  AuthController({required AuthNotifier authNotifier})
    : _authNotifier = authNotifier {
    _startAutoRefresh();
    checkAccessToken();
  }
  @override
  Future<HiveUserModel?> login(String email, String password) {
    return _authNotifier.login(email, password);
  }

  @override
  Future<HiveUserModel?> signup(
    String name,
    String email,
    String password,
    File? image,
  ) {
    final imagePath = image?.path ?? "";
    return _authNotifier.signup(name, email, password, imagePath);
  }

  @override
  Future<void> logout() {
    return _authNotifier.logout();
  }

  @override
  Future<String> refreshAccessToken(String refreshToken, String userId) {
    return _authNotifier.refreshAccessToken(refreshToken, userId);
  }

  @override
  Future<void> checkAccessToken() {
    return _authNotifier.checkAccessToken();
  }

  void dispose() {
    _timer?.cancel();
  }

  void _startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 5), (_) async {
      try {
        await checkAccessToken();
      } catch (error) {
        print(error);
      }
    });
  }
}
