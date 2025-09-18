import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class HiveUserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  @HiveField(4)
  String imageUrl;

  @HiveField(5)
  final String accessToken;

  @HiveField(6)
  final String refreshToken;

  HiveUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.imageUrl,
    required this.accessToken,
    required this.refreshToken,
  });

  factory HiveUserModel.fromJson(Map<String, dynamic> json) {
    return HiveUserModel(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? "",
      imageUrl: json['image_url'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "password": password,
    "image_url": imageUrl,
    "accessToken": accessToken,
    "refreshToken": refreshToken,
  };
}
