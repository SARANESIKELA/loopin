import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';

class StoryListScreen extends StatefulWidget {
  const StoryListScreen({super.key});

  @override
  State<StoryListScreen> createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  // index of the currently selected avatar, or null if none selected
  int? _selectedIndex;

  final names = ['mia.v01d', 'artsy_kira', 'midnight', 'helenka', 'casual'];

  void _select(int index) {
    setState(() => _selectedIndex = index);
  }

  void _dismissIfSelected(int index) {
    if (_selectedIndex == index) {
      setState(() => _selectedIndex = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stories')),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              names.length,
              (i) => Padding(
                padding: const EdgeInsets.only(right: 12),
                child: StoryAvatar(
                  index: i,
                  name: names[i],
                  isSelected: _selectedIndex == i,
                  onTap: () => _select(i),
                  onDoubleTap: () => _dismissIfSelected(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StoryAvatar extends StatelessWidget {
  final int index;
  final String name;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;

  const StoryAvatar({
    super.key,
    required this.index,
    required this.name,
    required this.isSelected,
    this.onTap,
    this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            width: 68,
            height: 68,
            padding: const EdgeInsets.all(3),
            decoration: isSelected
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFB075), Color(0xFFEA7C20)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.Black.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: AppTheme.BoxColor2,
                    borderRadius: BorderRadius.circular(18),
                  ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                'https://picsum.photos/seed/story$index/200',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 72,
            child: Text(
              name,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
