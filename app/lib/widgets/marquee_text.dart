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
  final GlobalKey _measureKey = GlobalKey();
  late final AnimationController _controller;
  double? _unitWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 10));
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box = _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.width <= 0) return;
    final width = box.size.width;
    if (!mounted) return;
    final seconds = (width / widget.pixelsPerSecond).clamp(3.0, 40.0);
    setState(() {
      _unitWidth = width;
      _controller.duration = Duration(milliseconds: (seconds * 1000).round());
      _controller.repeat();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildCopy() {
    return Padding(
      padding: EdgeInsets.only(right: widget.gap),
      child: Text(widget.text, style: widget.style, softWrap: false, overflow: TextOverflow.visible),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unit = _unitWidth;

    return ClipRect(
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            if (unit == null)
              // 최초 1회, 화면에 보이지 않게 실제 렌더 크기를 측정하기 위한 패스
              Opacity(
                opacity: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: KeyedSubtree(key: _measureKey, child: _buildCopy()),
                ),
              )
            else
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final dx = -_controller.value * unit;
                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    children: [
                      for (final offset in [dx, dx + unit, dx + unit * 2, dx + unit * 3])
                        Positioned(
                          left: offset,
                          top: 0,
                          bottom: 0,
                          child: Align(alignment: Alignment.centerLeft, child: _buildCopy()),
                        ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
