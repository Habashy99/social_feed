import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/auth.dart';
import 'package:social_feed/models/user.dart';

final loginProvider = FutureProvider.autoDispose.family<
  HiveUserModel?,
  ({String email, String password})
>((ref, args) async {
  final authController = ref.watch(authControllerProvider);
  try {
    final user = await authController.login(args.email, args.password);
    return user;
  } on SocketException {
    throw Exception("No internet connection. Please check your network.");
  } on FormatException {
    throw Exception("Invalid response from server.");
  } catch (error) {
    final message = error.toString();
    if (message.contains("email or password not provided")) {
      throw Exception("Please enter both email and password.");
    } else if (message.contains("User not found")) {
      throw Exception(
        "No account found with this email. Please sign up first.",
      );
    } else if (message.contains("Invalid password")) {
      throw Exception("Incorrect password. Please try again.");
    } else if (message.contains("Login failed")) {
      throw Exception("Something went wrong on the server. Please try again.");
    } else {
      throw Exception("Login failed. Please try again later. Details: $error");
    }
  }
});
final signupProvider = FutureProvider.autoDispose.family<
  HiveUserModel?,
  ({String name, String email, String password, File? image})
>((ref, args) async {
  final authController = ref.watch(authControllerProvider);
  try {
    final user = await authController.signup(
      args.name,
      args.email,
      args.password,
      args.image,
    );
    return user;
  } on SocketException {
    throw Exception("No internet connection. Please check your network.");
  } on FormatException {
    throw Exception("Invalid response from server.");
  } catch (error) {
    final message = error.toString();
    if (message.contains("Missing required fields")) {
      throw Exception("Please fill in all required fields.");
    } else if (message.contains("Email already in use")) {
      throw Exception("This email is already registered. Try logging in.");
    } else if (message.contains("Signup failed")) {
      throw Exception("Something went wrong on the server. Please try again.");
    } else {
      throw Exception("Signup failed. Please try again later. Details: $error");
    }
  }
});
final logoutProvider = FutureProvider.autoDispose((ref) async {
  final authController = ref.watch(authControllerProvider);
  await authController.logout();
});
final refreshAccessTokenProvider = FutureProvider.autoDispose
    .family<String, ({String refreshToken, String userId})>((
      ref,
      dynamic args,
    ) async {
      final authController = ref.watch(authControllerProvider);
      final newAccessToken = await authController.refreshAccessToken(
        args.refreshToken,
        args.userId,
      );
      return newAccessToken;
    });
final checkAccessTokenProvider = FutureProvider<void>((ref) async {
  final authController = ref.watch(authControllerProvider);
  await authController.checkAccessToken();
});
