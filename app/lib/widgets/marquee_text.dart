import 'package:flutter/material.dart';

/// 증권 시세 바처럼 텍스트가 끊김 없이 옆으로 계속 흘러가는 마키(ticker) 위젯.
class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double height;
  final double gap;
  final double pixelsPerSecond;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    required this.height,
    this.gap = 48,
    this.pixelsPerSecond = 40,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _unitWidth = 0;

  @override
  void initState() {
    super.initState();
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      textDirection: TextDirection.ltr,
    )..layout();
    _unitWidth = painter.width + widget.gap;

    final seconds = (_unitWidth / widget.pixelsPerSecond).clamp(3.0, 40.0);
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: (seconds * 1000).round()))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SizedBox(
        height: widget.height,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final dx = -_controller.value * _unitWidth;
            return Stack(
              children: [
                for (final offset in [dx, dx + _unitWidth, dx + _unitWidth * 2])
                  Positioned(
                    left: offset,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(right: widget.gap),
                        child: Text(widget.text, style: widget.style, softWrap: false),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
