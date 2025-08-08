class PostModel {
  final String id;
  final String title;
  final String? imageUrl;
  final String userId;
  PostModel({
    required this.id,
    required this.title,
    this.imageUrl,
    required this.userId,
  });
  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json["id"].toString(),
    title: json["title"],
    imageUrl: json["imageurl"] ?? "",
    userId: json["userid"].toString(),
  );
}
