import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/riverpod/users.dart';
import 'package:social_feed/models/user.dart';

abstract interface class IUser {
  Future<HiveUserModel?> getUserById(String id);
  Future<List<HiveUserModel>> getAllUsers();
  Future<HiveUserModel?> editUser(String id, String name, String imageUrl);
}

final usersControllerProvider = Provider.autoDispose(
  (ref) =>
      UsersController(usersNotifier: ref.watch(usersStateProvider.notifier)),
);

final editUserProvider = FutureProvider.autoDispose.family<
  HiveUserModel?,
  ({String id, String name, String imageUrl})
>((ref, args) async {
  final userController = ref.watch(usersControllerProvider);
  final user = await userController.editUser(args.id, args.name, args.imageUrl);
  return user;
});

class UsersController implements IUser {
  final UsersNotifier _usersNotifier;
  UsersController({required UsersNotifier usersNotifier})
    : _usersNotifier = usersNotifier;
  @override
  Future<HiveUserModel?> getUserById(String id) async {
    final user = await _usersNotifier.getUserById(id);
    return user;
  }

  @override
  Future<List<HiveUserModel>> getAllUsers() async {
    final users = await _usersNotifier.getAllUsers();
    return users;
  }

  @override
  Future<HiveUserModel?> editUser(
    String id,
    String? name,
    String? imageUrl,
  ) async {
    final editedUser = await _usersNotifier.editUser(id, name, imageUrl);
    return editedUser;
  }
}
