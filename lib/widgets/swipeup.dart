import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SwipeUpHint extends StatelessWidget {
  final bool isVisible;
  final Color color;

  const SwipeUpHint({
    super.key,
    required this.isVisible,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final iconSize = isTablet ? 36.0 : 28.0;
    final bottomPadding = size.height * 0.03;

    return Positioned(
      bottom: bottomPadding,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Icon(
            Icons.keyboard_arrow_up,
            size: iconSize,
            color: color.withOpacity(0.6),
          ),
        ],
      )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .fadeIn(duration: 800.ms)
          .then()
          .fadeOut(duration: 800.ms),
    );
  }
}