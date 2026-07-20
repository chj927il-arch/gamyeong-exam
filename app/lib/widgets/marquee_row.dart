import 'package:flutter/material.dart';

/// 위젯(카드 등)을 옆으로 끊김 없이 계속 흘려보내는 롤링 스트립.
/// [itemBuilder]는 한 사이클 분량의 콘텐츠를 만들며, 내부적으로 두 벌을 이어붙여
/// 스크롤 위치가 한 사이클만큼 이동하면 처음으로 되돌리는 방식(무한 루프처럼 보임)으로 흘려보낸다.
class MarqueeRow extends StatefulWidget {
  final WidgetBuilder itemBuilder;
  final double height;
  final double pixelsPerSecond;

  const MarqueeRow({
    super.key,
    required this.itemBuilder,
    required this.height,
    this.pixelsPerSecond = 36,
  });

  @override
  State<MarqueeRow> createState() => _MarqueeRowState();
}

class _MarqueeRowState extends State<MarqueeRow> with SingleTickerProviderStateMixin {
  final GlobalKey _measureKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  late final AnimationController _controller;
  double? _cycleWidth;

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
    _controller.duration = Duration(milliseconds: (seconds * 1000).round());
    _controller.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_controller.value * width);
      }
    });
    setState(() => _cycleWidth = width);
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cycleWidth = _cycleWidth;

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: cycleWidth == null
          ? Opacity(
              // 최초 1회, 화면에 보이지 않게 실제 렌더 크기를 측정하기 위한 패스
              opacity: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: KeyedSubtree(key: _measureKey, child: widget.itemBuilder(context)),
              ),
            )
          : SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Row(
                children: [widget.itemBuilder(context), widget.itemBuilder(context)],
              ),
            ),
    );
  }
}
