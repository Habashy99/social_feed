import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_feed/helpers/repository/auth_repo.dart';
import 'package:social_feed/models/user.dart';

final authRepository = Provider((ref) => AuthRepository());
final authStateProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<HiveUserModel?>>(
      (ref) => AuthNotifier(ref),
    );

class AuthNotifier extends StateNotifier<AsyncValue<HiveUserModel?>> {
  final Ref ref;
  AuthNotifier(this.ref) : super(const AsyncValue.data(null));
  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepository).login(email, password);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  ) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref
          .read(authRepository)
          .signup(name, email, password, imageUrl);
      state = AsyncValue.data(user);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<HiveUserModel?> getUserById(String id) async {
    state = const AsyncValue.loading();
    try {
      final user = await ref.read(authRepository).getUserById(id);
      state = AsyncValue.data(user);
      return user;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
