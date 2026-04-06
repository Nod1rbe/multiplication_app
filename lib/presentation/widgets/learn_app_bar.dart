import 'package:flutter/material.dart';
import 'package:multiplication_app/presentation/widgets/star_counter.dart';

import '../../../domain/entities/table_info.dart';

class LearnAppBar extends StatelessWidget {
  final TableInfo tableInfo;
  final int currentStep;
  final int stars;
  final VoidCallback onBack;

  const LearnAppBar({
    super.key,
    required this.tableInfo,
    required this.currentStep,
    required this.stars,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final color = tableInfo.color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new, size: 18, color: color),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${tableInfo.number}\'s jadvali ${tableInfo.emoji}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: currentStep / 10.0,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          StarCounter(count: stars),
        ],
      ),
    );
  }
}
