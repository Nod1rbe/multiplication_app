import 'package:flutter/material.dart';
import 'package:multiplication_app/presentation/learn/cubit/learn_cubit.dart';

import '../../../domain/entities/table_info.dart';

class QuestionCard extends StatefulWidget {
  final LearnState state;
  final TableInfo tableInfo;

  const QuestionCard({
    super.key,
    required this.state,
    required this.tableInfo,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.answerStatus == AnswerStatus.correct &&
        oldWidget.state.answerStatus != AnswerStatus.correct) {
      _bounceController.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.tableInfo.color;
    final step = widget.state.gameStep;

    return ScaleTransition(
      scale: _bounceAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.75)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                widget.tableInfo.emoji,
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 12),
              FittedBox(
                child: Text(
                  '${step.tableNumber} × ${step.multiplier} = ?',
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
              if (widget.state.showAnswer) ...[
                const SizedBox(height: 8),
                Text(
                  '= ${step.correctAnswer}',
                  style: const TextStyle(
                    fontSize: 34,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
