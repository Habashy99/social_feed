import 'package:dio/dio.dart';

abstract interface class IAuth {
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  );
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> getUserById(String id);
}

class AuthProvider implements IAuth {
  @override
  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
    String imageUrl,
  ) async {
    final dio = Dio();
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
    final dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8050/users/login',
      data: {"email": email, "password": password},
    );
    final data = response.data["user"];
    if (data == null) throw Exception("User not found in response");
    return data;
  }

  @override
  Future<Map<String, dynamic>> getUserById(String id) async {
    final dio = Dio();
    final response = await dio.post(
      'http://10.0.2.2:8050/users/getUserById',
      data: {"id": id},
    );
    final data = response.data["user"];
    if (data == null) throw Exception("User not found in response");
    return data;
  }
}
