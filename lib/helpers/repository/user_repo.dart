import 'package:social_feed/helpers/apis/user_api.dart';
import 'package:social_feed/models/user.dart';

class UsersRepository {
  final UsersApis _usersApis = UsersApis();
  final UsersMapper _usersMapper = UsersMapper();
  Future getUserById(String id) async {
    try {
      final json = await _usersApis.getUserById(id);
      final user = _usersMapper.mapFromJson(json);
      return user;
    } catch (error) {
      print("get user by id failed: $error");
      return null;
    }
  }

  Future<List<HiveUserModel>> getAllUsers() async {
    final json = await _usersApis.getAllUsers();
    return json.map((user) => _usersMapper.mapFromJson(user)).toList();
  }

  Future editUser(String id, String? name, String? imageUrl) async {
    try {
      final json = await _usersApis.editUser(id, name, imageUrl);
      final user = _usersMapper.mapFromJson(json);
      return user;
    } catch (error) {
      print("get user by id failed: $error");
      return null;
    }
  }
}

abstract interface class IUsersMapper {
  HiveUserModel mapFromJson(Map<String, dynamic> json);
}

class UsersMapper extends IUsersMapper {
  @override
  HiveUserModel mapFromJson(Map<String, dynamic> json) {
    return HiveUserModel.fromJson(json);
  }
}
