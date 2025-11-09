import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loopin/core/constants/app_theme.dart';
import 'package:loopin/data/models/post_model.dart';
import 'package:loopin/presentation/screens/create_post/create_post_screen.dart';
import 'package:loopin/presentation/screens/feed/widgets/story_avatar.dart';
import 'package:loopin/providers/post_provider.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<PostModel> get posts => context.watch<PostProvider>().posts;

  int? _selectedIndex;
  final List<String> _names = [
    'mia.v01d',
    'artsy_kira',
    'midnight',
    'helenka',
    'casual',
  ];

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return DateFormat('dd MMM').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppTheme.ScaffoldBackGroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔸 Stories row
            SizedBox(
              height: 110,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildAddStory(),
                  const SizedBox(width: 12),
                  ...List.generate(
                    5,
                    (i) => Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _buildStoryAvatar(i),
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Discover news',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.Black.withOpacity(0.86),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CreatePostScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, size: 22),
                    ),
                  ),
                ],
              ),
            ),

            // 🔸 Feed section
            Expanded(
              child: posts.isEmpty
                  ? const Center(
                      child: Text(
                        'No posts yet.\nTap + to create your first post!',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: AppTheme.Black54),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: posts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) =>
                          _buildDynamicPostCard(context, posts[i], width),
                    ),
            ),
          ],
        ),
      ),

      // 🔸 Bottom navigation bar
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ----------------- STORY SECTION -----------------
  Widget _buildAddStory() {
    return Column(
      children: [
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey, width: 1.4),
          ),
          child: const Center(
            child: Icon(Icons.add, size: 30, color: AppTheme.Black),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'you',
          style: TextStyle(fontSize: 12, color: AppTheme.Black),
        ),
      ],
    );
  }

  StoryAvatar _buildStoryAvatar(int i) {
    return StoryAvatar(
      index: i,
      name: _names[i % _names.length],
      isSelected: _selectedIndex == i,
      onTap: () => setState(() => _selectedIndex = i),
      onDoubleTap: () {
        if (_selectedIndex == i) setState(() => _selectedIndex = null);
      },
    );
  }

  // ----------------- DYNAMIC POST CARD -----------------
  Widget _buildDynamicPostCard(
    BuildContext context,
    PostModel post,
    double width,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(post.authorAvatar),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.authorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _timeAgo(post.createdAt),
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.Black54,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.more_horiz),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 Caption
          if (post.caption != null && post.caption!.isNotEmpty)
            Text(
              post.caption!,
              style: const TextStyle(fontSize: 15, height: 1.5),
            ),

          if (post.caption != null && post.caption!.isNotEmpty)
            const SizedBox(height: 12),

          // 🔹 Image (optional)
          if (post.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                width: width,
                height: 160,
                fit: BoxFit.cover,
              ),
            ),
          const SizedBox(height: 12),

          // 🔹 Actions row
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (post.id != null) {
                    context.read<PostProvider>().toggleLike(post.id!);
                  }
                },
                child: Row(
                  children: [
                    Icon(
                      post.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border_outlined,
                      color: post.isLiked ? Colors.red : AppTheme.Black,
                    ),
                    const SizedBox(width: 6),
                    Text('${post.likeCount}'),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              _iconWithCount(
                Icons.chat_bubble_outline,
                '${post.comments.length}',
              ),
              const SizedBox(width: 18),
              _iconWithCount(Icons.repeat, '0'),
              const Spacer(),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/like/100',
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${post.comments.length} comments',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppTheme.Black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconWithCount(IconData icon, String count) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(count, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  // ----------------- BOTTOM NAV -----------------
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(icon: Icons.radar, label: 'Feed', active: true),
          _navItem(icon: Icons.crop_square, label: 'Creations'),
          _navItemWithBadge(icon: Icons.message, label: 'Messages', badge: '6'),
          _navItem(icon: Icons.person, label: 'Profile'),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    bool active = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: active ? AppTheme.Black : AppTheme.Black54),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: active ? AppTheme.Black : AppTheme.Black54,
          ),
        ),
      ],
    );
  }

  Widget _navItemWithBadge({
    required IconData icon,
    required String label,
    String? badge,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, color: AppTheme.Black54),
            if (badge != null)
              Positioned(
                right: -8,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppTheme.Black54),
        ),
      ],
    );
  }
}
