import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/helpers/repository/auth_repo.dart';
import 'package:social_feed/models/user.dart';

final authRepository = Provider<AuthRepository>((ref) => AuthRepository());
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<List<HiveUserModel>>>(
      (ref) => AuthNotifier(ref.read(authRepository)),
    );

class AuthNotifier extends StateNotifier<AsyncValue<List<HiveUserModel>>> {
  final AuthRepository authRepository;
  AuthNotifier(this.authRepository) : super(const AsyncValue.loading());

  Future<HiveUserModel> login(String email, String password) async {
    try {
      final user = await authRepository.login(email, password);
      _updateState(newState: AsyncValue.data([user]));
      return user;
    } on DioException catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
      final errorMessage = error.response?.data["message"];
      throw Exception(errorMessage);
    }
  }

  Future<HiveUserModel> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  ) async {
    try {
      final user = await authRepository.signup(name, email, password, imageUrl);
      _updateState(newState: AsyncValue.data([user]));
      return user;
    } on DioException catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
      final errorMessage = error.response?.data["message"];
      throw Exception(errorMessage);
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    _updateState(newState: const AsyncValue.data([])); // no user
  }

  Future<String> refreshAccessToken(String refreshToken, String userId) async {
    try {
      final newAccessToken = await authRepository.refreshAccessToken(
        refreshToken,
        userId,
      );
      return newAccessToken;
    } on DioException catch (error) {
      final errorMessage = error.response?.data["message"];
      throw Exception(errorMessage);
    }
  }

  void _updateState({required AsyncValue<List<HiveUserModel>> newState}) {
    if (mounted) {
      state = newState;
    }
  }

  Future<void> checkAccessToken() async {
    final tokensBox = HiveService.getBox<String>('tokens');
    final userBox = HiveService.getBox<HiveUserModel>('userbox');
    final refreshToken = tokensBox.get('refreshToken');
    final accessToken = tokensBox.get('accessToken');
    final user = userBox.get('user');

    if (accessToken == null || user == null) {
      await logout();
      return;
    }

    final expirationDate = JwtDecoder.getExpirationDate(accessToken);
    final remaining = expirationDate.difference(DateTime.now());
    print(
      "Access token will expire in: ${remaining.inHours}h "
      "${remaining.inMinutes % 60}m ${remaining.inSeconds % 60}s",
    );
    if (remaining.isNegative) {
      print("Token expired. Logging out...");
      await logout();
      return;
    }
    if (remaining < const Duration(minutes: 5)) {
      if (refreshToken == null || JwtDecoder.isExpired(refreshToken)) {
        await logout();
        return;
      }

      try {
        print("Token is about to expire. Refreshing...");
        final newAccessToken = await refreshAccessToken(refreshToken, user.id);
        await tokensBox.put('accessToken', newAccessToken);
        print("Token refreshed successfully!");
      } catch (_) {
        await logout();
      }
    }
  }
}
