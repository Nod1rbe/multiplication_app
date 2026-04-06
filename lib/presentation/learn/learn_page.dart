import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_app/core/router/app_router.dart';
import 'package:multiplication_app/di/service_locator.dart';
import 'package:multiplication_app/presentation/result/result_page.dart';
import 'package:multiplication_app/presentation/widgets/answer_option_grid.dart';
import 'package:multiplication_app/presentation/widgets/learn_app_bar.dart';
import 'package:multiplication_app/presentation/widgets/mascot_feedback.dart';
import 'package:multiplication_app/presentation/widgets/question_card.dart';
import 'package:multiplication_app/presentation/widgets/streak_badge.dart';

import '../../../domain/entities/table_info.dart';
import '../widgets/table_reference_panel.dart';
import 'cubit/learn_cubit.dart';

class LearnPage extends StatelessWidget {
  final TableInfo tableInfo;

  const LearnPage({super.key, required this.tableInfo});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LearnCubit>()..initialize(tableInfo),
      child: _LearnView(tableInfo: tableInfo),
    );
  }
}

class _LearnView extends StatefulWidget {
  final TableInfo tableInfo;
  const _LearnView({required this.tableInfo});

  @override
  State<_LearnView> createState() => _LearnViewState();
}

class _LearnViewState extends State<_LearnView>
    with SingleTickerProviderStateMixin {
  late ConfettiController _confetti;
  late AnimationController _cardCtrl;
  late Animation<double> _cardScale;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _cardCtrl = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _cardScale = CurvedAnimation(parent: _cardCtrl, curve: Curves.elasticOut);
    _cardCtrl.forward();
  }

  @override
  void dispose() {
    _confetti.dispose();
    _cardCtrl.dispose();
    super.dispose();
  }

  int _lastStep = 1;
  bool _wasCompleted = false;

  void _onStepChanged(BuildContext context, LearnState curr) {
    if (curr.currentStep != _lastStep) {
      _lastStep = curr.currentStep;
      _cardCtrl.forward(from: 0);
    }
    if (!_wasCompleted && curr.isCompleted) {
      _wasCompleted = true;
      _confetti.play();
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRouter.result,
            arguments: ResultPageArgs(
              tableInfo: widget.tableInfo,
              stars: curr.stars,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LearnCubit, LearnState>(
      listener: _onStepChanged,
      builder: (context, state) {
        final cubit = context.read<LearnCubit>();
        final color = widget.tableInfo.color;

        return Scaffold(
          body: Stack(
            children: [
              // Gradient background
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      color.withOpacity(0.15),
                      Colors.white,
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // AppBar
                      LearnAppBar(
                        tableInfo: widget.tableInfo,
                        currentStep: state.currentStep,
                        stars: state.stars,
                        onBack: () => Navigator.pop(context, state.currentStep),
                      ),

                      const SizedBox(height: 10),

                      // Step indicator
                      Text(
                        '${state.currentStep} / 10',
                        style: TextStyle(
                          color: color.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Question card with scale animation
                      ScaleTransition(
                        scale: _cardScale,
                        child: QuestionCard(
                          state: state,
                          tableInfo: widget.tableInfo,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Mascot Feedback
                      MascotFeedback(status: state.answerStatus),

                      const SizedBox(height: 12),

                      // Hint button
                      TextButton.icon(
                        onPressed: state.isIdle ? cubit.toggleShowAnswer : null,
                        icon: Icon(
                          state.showAnswer
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 18,
                          color: color.withOpacity(0.7),
                        ),
                        label: Text(
                          state.showAnswer ? 'Yashirish' : 'Javobni ko\'rish',
                          style: TextStyle(color: color.withOpacity(0.7)),
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        'To\'g\'ri javobni tanlang:',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Answer options
                      AnswerOptionsGrid(
                        state: state,
                        tableInfo: widget.tableInfo,
                        onOptionSelected: cubit.selectAnswer,
                      ),

                      const SizedBox(height: 20),

                      // Streak badge
                      StreakBadge(streak: state.streak),

                      const SizedBox(height: 12),

                      // Table reference panel
                      TableReferencePanel(
                        tableInfo: widget.tableInfo,
                        isExpanded: state.showHint,
                        onToggle: cubit.toggleShowHint,
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Confetti
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 30,
                  colors: [color, Colors.yellow, Colors.green, Colors.pink],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
