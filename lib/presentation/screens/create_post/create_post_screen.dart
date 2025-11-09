import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';
import 'package:loopin/presentation/widgets/gradient_button.dart';
import 'package:provider/provider.dart';
import '../../../providers/post_provider.dart';

class Post {
  final String? caption;
  final String? imageUrl;
  final DateTime createdAt;

  Post({this.caption, this.imageUrl, DateTime? createdAt})
    : createdAt = createdAt ?? DateTime.now();
}

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  String? _selectedImageUrl;
  bool _isGenerating = false;
  bool _isPosting = false;

  // Sample images for quick selection
  final List<String> _sampleImages = List.generate(
    6,
    (i) => 'https://picsum.photos/seed/createpost$i/800/600',
  );

  // Example AI captions
  final List<String> _aiCaptions = [
    'Golden hour thoughts — when the sky blushes and I\'m grateful.',
    'Slow mornings, strong coffee, and small moments that matter.',
    'Collecting memories like seashells — each one a quiet story.',
    'Chasing light and good vibes only.',
    'A day spent outside is a day well lived.',
  ];

  Future<void> _generateCaptionWithAI() async {
    setState(() => _isGenerating = true);
    await Future.delayed(const Duration(seconds: 2)); // Simulate delay
    final randomCaption = _aiCaptions[Random().nextInt(_aiCaptions.length)];
    _captionController.text = randomCaption;
    setState(() => _isGenerating = false);
  }

  Future<void> _pickSampleImage() async {
    final picked = await showModalBottomSheet<String?>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SizedBox(
          height: 320,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Choose Image',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.7,
                        ),
                    itemCount: _sampleImages.length + 1,
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return GestureDetector(
                          onTap: () => Navigator.of(context).pop(null),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                              color: Colors.white,
                            ),
                            child: const Center(child: Text('No image')),
                          ),
                        );
                      }
                      final url = _sampleImages[i - 1];
                      return GestureDetector(
                        onTap: () => Navigator.of(context).pop(url),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            url,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, size: 36),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (picked != null) {
      setState(() => _selectedImageUrl = picked);
    }
  }

  Future<void> _post() async {
    final caption = _captionController.text.trim();
    if (caption.isEmpty && _selectedImageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a caption or an image')),
      );
      return;
    }

    setState(() => _isPosting = true);

    try {
      final postProvider = Provider.of<PostProvider>(context, listen: false);
      await postProvider.createPost(
        caption: caption.isEmpty ? null : caption,
        imageUrl: _selectedImageUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Post created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); // Return to feed
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return Scaffold(
      backgroundColor: AppTheme.ScaffoldBackGroundColor,
      appBar: AppBar(
        title: const Text('Create Post'),
        centerTitle: true,
        backgroundColor: AppTheme.ScaffoldBackGroundColor,
        foregroundColor: AppTheme.Black,
        elevation: 0,
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _post,
            child: _isPosting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text(
                    'Post',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.Black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ----- User row (avatar + privacy selector) -----
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/me/100',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'You',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Public',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppTheme.Black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ----- Caption input -----
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.Black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _captionController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Write a caption...',
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ----- Image preview and actions -----
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.Black.withOpacity(0.02),
                            blurRadius: 6,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _selectedImageUrl == null
                          ? const Center(
                              child: Text(
                                'No image selected',
                                style: TextStyle(color: AppTheme.Black54),
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _selectedImageUrl!,
                                height: 120,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.broken_image,
                                    size: 36,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickSampleImage,
                        icon: const Icon(Icons.photo, color: AppTheme.Black),
                        label: const Text(
                          'Pick',
                          style: TextStyle(color: AppTheme.Black),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          elevation: 0,
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedImageUrl != null)
                        OutlinedButton(
                          onPressed: () =>
                              setState(() => _selectedImageUrl = null),
                          child: const Text(
                            'Remove',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ----- Generate caption hint -----
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isGenerating ? null : _generateCaptionWithAI,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.smart_toy, color: AppTheme.Black),
                      label: Text(
                        _isGenerating
                            ? 'Generating...'
                            : 'Generate Caption with AI',
                        style: const TextStyle(color: AppTheme.Black),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              const Text(
                'Tip: Generate a caption automatically and tweak it before posting.',
                style: TextStyle(color: AppTheme.Black54),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  onPressed: _isPosting ? () {} : _post,
                  child: _isPosting
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Post',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}
