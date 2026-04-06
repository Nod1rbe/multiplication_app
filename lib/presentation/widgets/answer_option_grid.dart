import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multiplication_app/presentation/learn/cubit/learn_cubit.dart';

import '../../../domain/entities/table_info.dart';

class AnswerOptionsGrid extends StatelessWidget {
  final LearnState state;
  final TableInfo tableInfo;
  final ValueChanged<int> onOptionSelected;

  const AnswerOptionsGrid({
    super.key,
    required this.state,
    required this.tableInfo,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: state.gameStep.options
            .map((opt) => _AnswerButton(
                  option: opt,
                  state: state,
                  tableInfo: tableInfo,
                  onTap: () {
                    HapticFeedback.mediumImpact();
                    onOptionSelected(opt);
                  },
                ))
            .toList(),
      ),
    );
  }
}

class _AnswerButton extends StatefulWidget {
  final int option;
  final LearnState state;
  final TableInfo tableInfo;
  final VoidCallback onTap;

  const _AnswerButton({
    required this.option,
    required this.state,
    required this.tableInfo,
    required this.onTap,
  });

  @override
  State<_AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<_AnswerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  bool get _isSelected => widget.state.selectedAnswer == widget.option;
  bool get _isCorrectOption =>
      widget.option == widget.state.gameStep.correctAnswer;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(_shakeCtrl);
  }

  @override
  void didUpdateWidget(_AnswerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isSelected &&
        widget.state.answerStatus == AnswerStatus.wrong &&
        oldWidget.state.answerStatus != AnswerStatus.wrong) {
      _shakeCtrl.forward(from: 0).then((_) => _shakeCtrl.reverse());
    }
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  (Color, Color, Color) get _colors {
    if (_isSelected) {
      if (widget.state.answerStatus == AnswerStatus.correct) {
        return (Colors.green.shade100, Colors.green.shade800, Colors.green);
      } else {
        return (Colors.red.shade100, Colors.red.shade800, Colors.red);
      }
    }
    if (widget.state.selectedAnswer != null && _isCorrectOption) {
      return (
        Colors.green.shade50,
        Colors.green.shade700,
        Colors.green.shade300
      );
    }
    return (Colors.white, Colors.black87, Colors.grey.shade300);
  }

  @override
  Widget build(BuildContext context) {
    final (bgColor, textColor, borderColor) = _colors;

    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (ctx, child) {
        final offset =
            _isSelected && widget.state.answerStatus == AnswerStatus.wrong
                ? sin(_shakeAnim.value * pi * 6) * 8
                : 0.0;
        return Transform.translate(
          offset: Offset(offset, 0),
          child: child,
        );
      },
      child: GestureDetector(
        onTap: widget.state.isIdle ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '${widget.option}',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
