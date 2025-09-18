import 'package:intl/intl.dart';

class StoryModel {
  final String? id;
  final String? userId;
  final String imageUrl;
  final DateTime createdAt;

  StoryModel({
    this.id,
    this.userId,
    required this.imageUrl,
    required this.createdAt,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'].toString(),
      userId: json['userid'].toString(),
      imageUrl: json['imageurl'],
      createdAt: _parseDate(json["created_at"]),
    );
  }
  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    final dateStr = date.toString();

    // Try ISO parsing first
    try {
      return DateTime.parse(dateStr);
    } catch (_) {}

    // Parse JS-style date string: "Sun Aug 31 2025 17:15:58 GMT+0300 ..."
    try {
      final formatter = DateFormat("EEE MMM dd yyyy HH:mm:ss 'GMT'Z", "en_US");
      return formatter.parse(dateStr);
    } catch (_) {
      return DateTime.now();
    }
  }
}
