import 'package:flutter/material.dart';
import 'package:loopin/core/constants/app_theme.dart';

class LoadingDots extends StatefulWidget {
  final double size;
  final double spacing;
  final Duration duration;
  final Color? color;

  const LoadingDots({
    super.key,
    this.size = 8,
    this.spacing = 6,
    this.duration = const Duration(milliseconds: 900),
    this.color,
  });

  @override
  State<LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<Animation<double>> _anims;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();

    // create 3 staggered animations using intervals
    _anims = List.generate(3, (i) {
      // stagger start times
      final start = i * 0.15;
      final end = start + 0.6;
      return TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 0.4,
            end: 1.0,
          ).chain(CurveTween(curve: Curves.easeOut)),
          weight: 50,
        ),
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: 0.4,
          ).chain(CurveTween(curve: Curves.easeIn)),
          weight: 50,
        ),
      ]).animate(
        CurvedAnimation(
          parent: _ctrl,
          curve: Interval(start.clamp(0.0, 1.0), end.clamp(0.0, 1.0)),
        ),
      );
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _buildDot(Animation<double> anim) {
    final dotColor = widget.color ?? Colors.white;
    return ScaleTransition(
      scale: anim,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: dotColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppTheme.Black.withOpacity(0.12),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(_anims[0]),
        SizedBox(width: widget.spacing),
        _buildDot(_anims[1]),
        SizedBox(width: widget.spacing),
        _buildDot(_anims[2]),
      ],
    );
  }
}
