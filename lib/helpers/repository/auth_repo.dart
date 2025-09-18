import 'package:social_feed/helpers/hive.dart';
import 'package:social_feed/helpers/apis/auth_api.dart';
import 'package:social_feed/models/user.dart';

class AuthRepository {
  final AuthApis _authProvider = AuthApis();
  final AuthMapper _authMapper = AuthMapper();

  Future<HiveUserModel> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  ) async {
    try {
      final json = await _authProvider.signup(name, email, password, imageUrl);
      final user = _authMapper.mapFromJson(json);
      final userBox = await HiveService.getBox<HiveUserModel>('userbox');
      await userBox.put('user', user);
      final tokensBox = await HiveService.getBox<String>('tokens');
      await tokensBox.put('accessToken', user.accessToken);
      await tokensBox.put('refreshToken', user.refreshToken);
      return user;
    } catch (error) {
      print(">>> ERROR during login: $error");
      rethrow;
    }
  }

  Future<HiveUserModel> login(String email, String password) async {
    try {
      final json = await _authProvider.login(email, password);
      final user = _authMapper.mapFromJson(json);
      final userBox = await HiveService.getBox<HiveUserModel>('userbox');
      await userBox.put('user', user);
      final tokensBox = await HiveService.getBox<String>('tokens');
      await tokensBox.put('accessToken', user.accessToken);
      await tokensBox.put('refreshToken', user.refreshToken);
      return user;
    } catch (error) {
      print(">>> ERROR during login: $error");
      rethrow;
    }
  }

  Future<void> logout() async {
    final userBox = await HiveService.getBox<HiveUserModel>('userbox');
    final tokensBox = await HiveService.getBox<String>('tokens');
    await userBox.clear();
    await tokensBox.clear();
  }

  Future<String> refreshAccessToken(String refreshToken, String userId) async {
    try {
      final json = await _authProvider.refreshAccessToken(refreshToken, userId);
      final tokensBox = await HiveService.getBox<String>('tokens');
      await tokensBox.put('accessToken', json);
      return json;
    } catch (error) {
      print(">>> ERROR during login: $error");
      rethrow;
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
