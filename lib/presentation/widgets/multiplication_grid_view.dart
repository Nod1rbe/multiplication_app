import 'package:flutter/material.dart';

class MultiplicationGridView extends StatefulWidget {
  final int rows;
  final int cols;
  final String emoji;

  const MultiplicationGridView({
    super.key,
    required this.rows,
    required this.cols,
    this.emoji = '🍎',
  });

  @override
  State<MultiplicationGridView> createState() => _MultiplicationGridViewState();
}

class _MultiplicationGridViewState extends State<MultiplicationGridView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(MultiplicationGridView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.rows != widget.rows || oldWidget.cols != widget.cols) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.rows * widget.cols;
    
    // We limit the size for visual clarity
    final double itemSize = total > 50 ? 20 : (total > 20 ? 30 : 40);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.rows, (r) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.cols, (c) {
            final index = r * widget.cols + c;
            final delay = index / total;
            
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final start = delay * 0.8;
                final end = start + 0.2;
                final opacity = Interval(start, end.clamp(0.0, 1.0), curve: Curves.easeOut)
                    .transform(_controller.value);
                final scale = Interval(start, end.clamp(0.0, 1.0), curve: Curves.elasticOut)
                    .transform(_controller.value);

                return Opacity(
                  opacity: opacity,
                  child: Transform.scale(
                    scale: scale,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        widget.emoji,
                        style: TextStyle(fontSize: itemSize),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        );
      }),
    );
  }
}
