class PostModel {
  final String id;
  final String text;
  final String createdAt;
  final String imageUrl;
  final String userId;
  final String userName;
  final String userImageUrl;
  final String totalComments;
  final String totalFavorites;
  final bool isFavorite;
  PostModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.imageUrl,
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.totalComments,
    required this.totalFavorites,
    required this.isFavorite,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"].toString(),
    text: json["text"] ?? "",
    createdAt: json["created_at"] ?? "",
    imageUrl: json["imageurl"] ?? "",
    userId: json["userid"].toString(),
    userName: json["userName"] ?? "",
    userImageUrl: json["userImageUrl"] ?? "",
    totalComments: json["totalComments"].toString(),
    totalFavorites: json["totalFavorites"].toString(),
    isFavorite: json["isFavorite"] ?? false,
  );
}
