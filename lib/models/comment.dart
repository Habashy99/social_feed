class CommentModel {
  final String id;
  final String comment;
  final String? commentPhoto;
  final String userId;
  final String postId;
  CommentModel({
    required this.id,
    required this.comment,
    this.commentPhoto,
    required this.userId,
    required this.postId,
  });
  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['id'].toString(),
    comment: json["comment"],
    commentPhoto: json["commentPhoto"] ?? "",
    userId: json['userId'].toString(),
    postId: json['postId'].toString(),
  );
}
