import 'package:flutter/material.dart';
import '../learn/cubit/learn_cubit.dart';

class MascotFeedback extends StatelessWidget {
  final AnswerStatus status;
  const MascotFeedback({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    if (status == AnswerStatus.idle) {
      return const Column(
        children: [
          Text('🦉', style: TextStyle(fontSize: 40)),
          SizedBox(height: 4),
          Text(
            'Tayyormisan? Qani boshla!',
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.blueGrey),
          ),
        ],
      );
    }

    final bool isCorrect = status == AnswerStatus.correct;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isCorrect ? Colors.green.shade200 : Colors.red.shade200,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isCorrect ? '🦉✨' : '🦉🧐',
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 12),
          Text(
            isCorrect ? 'Barakalla! To\'g\'ri!' : 'Daqiqaroq o\'ylab ko\'r...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
