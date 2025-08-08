import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/helpers/providers/auth_api.dart';
import 'package:social_feed/models/user.dart';

class AuthRepository {
  final AuthProvider _authProvider = AuthProvider();
  final AuthMapper _authMapper = AuthMapper();
  Future signup(
    String name,
    String email,
    String password,
    String imageUrl,
  ) async {
    try {
      final json = await _authProvider.signup(name, email, password, imageUrl);
      final user = _authMapper.mapFromJson(json);
      final userBox = HiveService.getUserBox();
      await userBox.clear();
      await userBox.put('user', user);
      return user;
    } catch (error) {
      print("Signup failed: $error");
      return null;
    }
  }

  Future login(String email, String password) async {
    try {
      final json = await _authProvider.login(email, password);
      final user = _authMapper.mapFromJson(json);
      final userBox = HiveService.getUserBox();
      await userBox.clear();
      await userBox.put('user', user);
      return user;
    } catch (error) {
      print("Login failed: $error");
      return null;
    }
  }

  Future getUserById(String id) async {
    try {
      final json = await _authProvider.getUserById(id);
      final user = _authMapper.mapFromJson(json);
      return user;
    } catch (error) {
      print("get user by id failed: $error");
      return null;
    }
  }
}

abstract interface class IAuthMapper {
  HiveUserModel mapFromJson(Map<String, dynamic> json);
}

class AuthMapper extends IAuthMapper {
  @override
  HiveUserModel mapFromJson(Map<String, dynamic> json) {
    return HiveUserModel.fromJson(json);
  }
}
