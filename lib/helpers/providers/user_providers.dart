import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_feed/helpers/controllers/user.dart';
import 'package:social_feed/models/user.dart';

final userProvider = FutureProvider.autoDispose.family<HiveUserModel?, String>((
  ref,
  id,
) async {
  final userController = ref.watch(usersControllerProvider);
  final user = await userController.getUserById(id);
  return user;
});
final usersProvider = FutureProvider.autoDispose<List<HiveUserModel>>((
  ref,
) async {
  final userController = ref.watch(usersControllerProvider);
  final users = await userController.getAllUsers();
  return users;
});
