import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/routeConstant.dart';

class AnimatedNotificationBell extends StatefulWidget {
  const AnimatedNotificationBell({super.key});

  @override
  State<AnimatedNotificationBell> createState() =>
      _AnimatedNotificationBellState();
}

class _AnimatedNotificationBellState extends State<AnimatedNotificationBell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Define the Controller
    // The goal is 2-3 pulses per minute, which is one pulse every 20-30 seconds.
    // Let's go with one pulse every 25 seconds for the full loop duration.
    // The actual pulse animation will be a quick 1-second burst.

    // A Duration of 25 seconds for the full cycle (pulse + pause)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat(); // Keep repeating the cycle

    // 2. Define the Animation (Scale)
    // The scale will go from 1.0 (normal size) to 1.1 (slightly bigger) and back to 1.0.
    // We only want the scaling to happen at the very beginning of the 25-second cycle.
    _scaleAnimation = TweenSequence<double>([
      // Start the pulse (0% to 2% of the total 25s duration)
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 0.01),
      // Scale down (2% to 4% of the total 25s duration)
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 0.01),
      // Pause (4% to 100% of the total 25s duration)
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 0.98),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Define the colors for the yellow-gold gradient
    const goldColor = Color(0xFFFFD700);
    const darkIconColor = Color(0xFF2C3E50);
    const redDotColor = Color(0xFFEA4335);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        // Outer Container for the "glowing" border effect
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: goldColor.withValues(alpha: .2), // Translucent gold glow
              blurRadius: 7.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: InkWell(
          onTap: () => context.push(AppRoutes.notification),
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              // Inner Container
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: goldColor, width: 1.5),
              ),
              child: Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // 1. The Bell Icon
                    const Icon(
                      Icons.notifications_none,
                      color: darkIconColor,
                      size: 28,
                    ),

                    // 2. The Red Notification Dot
                    Positioned(
                      top: -2,
                      right: -2,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: redDotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
