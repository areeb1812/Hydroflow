import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveLiquidWidget extends StatefulWidget {
  final double percentage; // 0.0 to 1.0+
  final double height;
  final double width;
  final Widget? child;

  const WaveLiquidWidget({
    super.key,
    required this.percentage,
    this.height = 240,
    this.width = double.infinity,
    this.child,
  });

  @override
  State<WaveLiquidWidget> createState() => _WaveLiquidWidgetState();
}

class _WaveLiquidWidgetState extends State<WaveLiquidWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(32),
          child: Container(
            height: widget.height,
            width: widget.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              color: const Color(0xFF151C33),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00F5D4).withValues(alpha: 0.15),
                  blurRadius: 25,
                  spreadRadius: 1,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                CustomPaint(
                  size: Size(widget.width, widget.height),
                  painter: _WavePainter(
                    animationValue: _controller.value,
                    percentage: widget.percentage,
                  ),
                ),
                if (widget.child != null) Center(child: widget.child!),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  final double animationValue;
  final double percentage;

  _WavePainter({
    required this.animationValue,
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final clampedFill = percentage.clamp(0.0, 1.0);
    final fillHeight = size.height * (1.0 - clampedFill);

    // Front Wave Paint (Glowing cyan gradient)
    final Paint frontPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF00F5D4).withValues(alpha: 0.85),
          const Color(0xFF00BBF9).withValues(alpha: 0.95),
          const Color(0xFF0077B6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    // Back Wave Paint (Deeper aqua translucent)
    final Paint backPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF48CAE4).withValues(alpha: 0.4),
          const Color(0xFF0077B6).withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final Path backPath = Path();
    final Path frontPath = Path();

    // Back Wave Calculation
    backPath.moveTo(0, fillHeight);
    for (double i = 0; i <= size.width; i++) {
      double waveDelta = math.sin((i / size.width * 2 * math.pi) +
              (animationValue * 2 * math.pi) +
              1.5) *
          8;
      backPath.lineTo(i, fillHeight + waveDelta);
    }
    backPath.lineTo(size.width, size.height);
    backPath.lineTo(0, size.height);
    backPath.close();

    canvas.drawPath(backPath, backPaint);

    // Front Wave Calculation
    frontPath.moveTo(0, fillHeight);
    for (double i = 0; i <= size.width; i++) {
      double waveDelta = math.sin((i / size.width * 2 * math.pi) -
              (animationValue * 2 * math.pi)) *
          10;
      frontPath.lineTo(i, fillHeight + waveDelta);
    }
    frontPath.lineTo(size.width, size.height);
    frontPath.lineTo(0, size.height);
    frontPath.close();

    canvas.drawPath(frontPath, frontPaint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.percentage != percentage;
  }
}
