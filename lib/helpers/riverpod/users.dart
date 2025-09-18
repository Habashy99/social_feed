import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/repository/user_repo.dart';
import 'package:social_feed/models/user.dart';

final usersRepository = Provider<UsersRepository>((ref) => UsersRepository());
final usersStateProvider =
    StateNotifierProvider<UsersNotifier, AsyncValue<List<HiveUserModel>>>(
      (ref) => UsersNotifier(ref.read(usersRepository)),
    );

class UsersNotifier extends StateNotifier<AsyncValue<List<HiveUserModel>>> {
  final UsersRepository userRepository;
  UsersNotifier(this.userRepository) : super(const AsyncValue.loading());

  Future<HiveUserModel> getUserById(String id) async {
    try {
      final user = await userRepository.getUserById(id);
      if (user != null) {
        _updateState(newState: AsyncValue.data([user]));
        return user;
      }
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    throw Exception("User not found");
  }

  Future<List<HiveUserModel>> getAllUsers() async {
    try {
      final users = await userRepository.getAllUsers();
      _updateState(newState: AsyncValue.data(users));
      return users;
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
      return [];
    }
  }

  Future<HiveUserModel> editUser(
    String id,
    String? name,
    String? imageUrl,
  ) async {
    try {
      final user = await userRepository.editUser(id, name, imageUrl);
      if (user != null) {
        _updateState(newState: AsyncValue.data([user]));
        return user;
      }
    } catch (error, stackTrace) {
      _updateState(newState: AsyncValue.error(error, stackTrace));
    }
    throw Exception("User not found");
  }

  void _updateState({required AsyncValue<List<HiveUserModel>> newState}) {
    if (mounted) {
      state = newState;
    }
  }
}
