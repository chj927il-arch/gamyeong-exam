import 'package:flutter/material.dart';

/// 위젯(카드 등)을 옆으로 끊김 없이 계속 흘려보내는 롤링 스트립.
/// [MarqueeText]와 동일한 측정 방식을 위젯 전반에 적용한 범용 버전.
class MarqueeRow extends StatefulWidget {
  final Widget child;
  final double height;
  final double pixelsPerSecond;

  const MarqueeRow({
    super.key,
    required this.child,
    required this.height,
    this.pixelsPerSecond = 36,
  });

  @override
  State<MarqueeRow> createState() => _MarqueeRowState();
}

class _MarqueeRowState extends State<MarqueeRow> with SingleTickerProviderStateMixin {
  final GlobalKey _measureKey = GlobalKey();
  late final AnimationController _controller;
  double? _unitWidth;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20));
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  void _measure() {
    final box = _measureKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize || box.size.width <= 0) return;
    final width = box.size.width;
    if (!mounted) return;
    final seconds = (width / widget.pixelsPerSecond).clamp(4.0, 120.0);
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
                  child: KeyedSubtree(key: _measureKey, child: widget.child),
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
                      for (final offset in [dx, dx + unit, dx + unit * 2])
                        Positioned(
                          left: offset,
                          top: 0,
                          bottom: 0,
                          child: Align(alignment: Alignment.centerLeft, child: child),
                        ),
                    ],
                  );
                },
                child: widget.child,
              ),
          ],
        ),
      ),
    );
  }
}
