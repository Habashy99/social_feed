class CommentModel {
  final String id;
  final String comment;
  final String? commentPhoto;
  final String createdAt;
  final String userId;
  final String postId;
  final String userName;
  final String userImageUrl;
  final String totalFavorites;
  final bool isFavorite;
  CommentModel({
    required this.id,
    required this.comment,
    this.commentPhoto,
    required this.createdAt,
    required this.userId,
    required this.postId,
    required this.userName,
    required this.userImageUrl,
    required this.totalFavorites,
    required this.isFavorite,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['id'].toString(),
    comment: json["comment"],
    commentPhoto: json["commentphoto"] ?? "",
    createdAt: json["created_at"],
    userId: json['userid'].toString(),
    postId: json['postid'].toString(),
    userName: json['userName'] ?? '',
    userImageUrl: json['userImageUrl'] ?? '',
    totalFavorites: json['totalFavorites'].toString(),
    isFavorite: json["isFavorite"] ?? false,
  );
}
