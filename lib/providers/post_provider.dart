import 'package:flutter/foundation.dart';
import '../data/models/post_model.dart';

class PostProvider extends ChangeNotifier {
  final List<PostModel> _posts = [];
  List<PostModel> get posts => List.unmodifiable(_posts.reversed);
  Future<void> createPost({String? caption, String? imageUrl}) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final newPost = PostModel(
      id: DateTime.now().millisecondsSinceEpoch,
      caption: caption,
      imageUrl: imageUrl,
      authorName: 'You',
      authorAvatar: 'https://picsum.photos/seed/me/100',
      createdAt: DateTime.now(),
      likeCount: 0,
      comments: const [],
      isLiked: false,
    );

    _posts.add(newPost);
    notifyListeners();
  }

  void toggleLike(int postId) {
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx == -1) return;

    final p = _posts[idx];
    final updated = p.copyWith(
      isLiked: !p.isLiked,
      likeCount: p.isLiked ? (p.likeCount - 1) : (p.likeCount + 1),
    );
    _posts[idx] = updated;
    notifyListeners();
  }

  Future<void> loadFromDb() async {}
}
