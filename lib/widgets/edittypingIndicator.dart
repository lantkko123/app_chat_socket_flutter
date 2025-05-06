import 'package:flutter/material.dart';

class CurvedTypingIndicator extends StatefulWidget {
  const CurvedTypingIndicator({super.key});

  @override
  State<CurvedTypingIndicator> createState() => _CurvedTypingIndicatorState();
}

class _CurvedTypingIndicatorState extends State<CurvedTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    _animations = List.generate(3, (index) {
      return Tween(begin: 0.5, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.2 * index,
            0.6 + 0.2 * index,
            curve: Curves.easeInOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double dotSize = 10;

    return SizedBox(
      width: 60,
      height: 25,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Transform.translate(
                offset: const Offset(-10, -2),
                child: Dot(
                  dotSize: dotSize * _animations[0].value,
                  opacity: _animations[0].value,
                ),
              ),
              Transform.translate(
                offset: const Offset(0, 1),
                child: Dot(
                  dotSize: dotSize * _animations[1].value,
                  opacity: _animations[1].value,
                ),
              ),
              Transform.translate(
                offset: const Offset(10,-2),
                child: Dot(
                  dotSize: dotSize * _animations[2].value,
                  opacity: _animations[2].value,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Dot extends StatelessWidget {
  final double dotSize;
  final double opacity;

  const Dot({super.key, required this.dotSize, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 227, 232, 236),
              Color.fromARGB(255, 95, 77, 185),
            ],
          ),
        ),
      ),
    );
  }
}
