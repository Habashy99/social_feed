import 'package:dio/dio.dart';

abstract interface class IAuth {
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  );
  Future<Map<String, dynamic>> login(String email, String password);
  Future<String> refreshAccessToken(String refreshToken, String userId);
}

class AuthApis implements IAuth {
  final dio = Dio();
  @override
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  ) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/users/signup',
      data: {
        "name": name,
        "email": email,
        "password": password,
        "image_url": imageUrl,
      },
    );
    final data = response.data["user"];
    if (data == null) throw Exception("User not found in response");
    return data;
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/users/login',
      data: {"email": email, "password": password},
    );
    final data = response.data["user"];
    if (data == null) throw Exception("User not found in response");
    return data;
  }

  @override
  Future<String> refreshAccessToken(String refreshToken, String userId) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/users/refreshAccessToken',
      data: {"refreshToken": refreshToken, "userId": userId},
    );
    final data = response.data["newAccessToken"];
    if (data == null) throw Exception("refresh Access Token failed");
    return data;
  }
}
