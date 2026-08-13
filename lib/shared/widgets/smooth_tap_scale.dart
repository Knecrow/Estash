import 'package:flutter/material.dart';

class SmoothTapScale extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;

  const SmoothTapScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<SmoothTapScale> createState() => _SmoothTapScaleState();
}

class _SmoothTapScaleState extends State<SmoothTapScale> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap == null ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.onTap == null ? null : (_) => setState(() => _isPressed = false),
      onTapCancel: widget.onTap == null ? null : () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
