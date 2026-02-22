import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SwipeUpHint extends StatelessWidget {
  final bool isVisible;
  final Color color;

  const SwipeUpHint({
    required this.isVisible,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Positioned(
      bottom: 24,
      left: 0,
      right: 0,
      child: Column(
        children: [
          Icon(
            Icons.keyboard_arrow_up,
            size: 28,
            color: color.withOpacity(0.6),
          ),
         
        ],
      )
         
    );
  }
}