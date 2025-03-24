import 'package:flutter/material.dart';

class RotatingButton extends StatefulWidget {
  final VoidCallback onPressed;
  final ImageProvider image;

  const RotatingButton({
    super.key,
    required this.onPressed,
    required this.image,
  });

  @override
  createState() => _RotatingButtonState();
}

class _RotatingButtonState extends State<RotatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _animation.value * 2 * 3.141592653589793,
            child: Image(
              image: widget.image, // 使用 Image 小部件来显示图片
              width: 80, // 可以根据需要调整图片的大小
              height: 80,
            ),
          );
        },
      ),
    );
  }
}