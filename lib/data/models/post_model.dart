import 'dart:convert';

class PostModel {
  final int? id;
  final String? caption;
  final String? imageUrl;
  final String authorName;
  final String authorAvatar;
  final DateTime createdAt;
  final int likeCount;
  final List<Comment> comments;
  final bool isLiked;

  PostModel({
    this.id,
    this.caption,
    this.imageUrl,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
    this.likeCount = 0,
    this.comments = const [],
    this.isLiked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'imageUrl': imageUrl,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'comments': jsonEncode(comments.map((c) => c.toMap()).toList()),
      'isLiked': isLiked ? 1 : 0,
    };
  }

  // Create PostModel from database Map
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      caption: map['caption'],
      imageUrl: map['imageUrl'],
      authorName: map['authorName'],
      authorAvatar: map['authorAvatar'],
      createdAt: DateTime.parse(map['createdAt']),
      likeCount: map['likeCount'] ?? 0,
      comments: map['comments'] != null
          ? (jsonDecode(map['comments']) as List)
                .map((c) => Comment.fromMap(c))
                .toList()
          : [],
      isLiked: map['isLiked'] == 1,
    );
  }

  // Copy with method for updating specific fields
  PostModel copyWith({
    int? id,
    String? caption,
    String? imageUrl,
    String? authorName,
    String? authorAvatar,
    DateTime? createdAt,
    int? likeCount,
    List<Comment>? comments,
    bool? isLiked,
  }) {
    return PostModel(
      id: id ?? this.id,
      caption: caption ?? this.caption,
      imageUrl: imageUrl ?? this.imageUrl,
      authorName: authorName ?? this.authorName,
      authorAvatar: authorAvatar ?? this.authorAvatar,
      createdAt: createdAt ?? this.createdAt,
      likeCount: likeCount ?? this.likeCount,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class Comment {
  final String id;
  final String text;
  final String authorName;
  final String authorAvatar;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.authorName,
    required this.authorAvatar,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Comment.fromMap(Map<String, dynamic> map) {
    return Comment(
      id: map['id'],
      text: map['text'],
      authorName: map['authorName'],
      authorAvatar: map['authorAvatar'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
