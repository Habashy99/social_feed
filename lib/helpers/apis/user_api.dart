import 'package:social_feed/helpers/custom_dio.dart';

abstract interface class IUser {
  Future<Map<String, dynamic>> getUserById(String id);
  Future<List<dynamic>> getAllUsers();
  Future<Map<String, dynamic>> editUser(
    String id,
    String name,
    String imageUrl,
  );
}

class UsersApis implements IUser {
  final dio = ApiClient.instance;
  @override
  Future<Map<String, dynamic>> getUserById(String id) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/users/getUserById',
      data: {"id": id},
    );
    final data = response.data["user"];
    if (data == null) throw Exception("User not found in response");
    return data;
  }

  @override
  Future<List<dynamic>> getAllUsers() async {
    final response = await dio.post('http://10.0.2.2:8050/users/');
    final data = response.data["users"];
    if (data == null) throw Exception("User not found in response");
    return data as List<dynamic>;
  }

  @override
  Future<Map<String, dynamic>> editUser(
    String id,
    String? name,
    String? imageUrl,
  ) async {
    final response = await dio.post(
      'http://10.0.2.2:8050/users/editUser',
      data: {"id": id, "name": name, "imageUrl": imageUrl},
    );
    final data = response.data["updatedUser"];
    if (data == null) throw Exception("User not found in response");
    return data;
  }
}
