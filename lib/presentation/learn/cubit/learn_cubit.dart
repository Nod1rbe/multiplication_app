import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_app/domain/usecases/table_use_case.dart';

import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/game_step.dart';
import '../../../domain/entities/table_info.dart';

part 'learn_state.dart';

class LearnCubit extends Cubit<LearnState> {
  final SaveProgressUseCase saveProgress;
  final GenerateGameStepUseCase generateStep;

  late TableInfo _tableInfo;
  Timer? _timer;

  LearnCubit({
    required this.saveProgress,
    required this.generateStep,
  }) : super(const LearnState(
          currentStep: 1,
          gameStep: GameStep(
            tableNumber: 2,
            multiplier: 1,
            options: [2, 4, 6, 8],
          ),
        ));

  void initialize(TableInfo tableInfo) {
    _tableInfo = tableInfo;
    final step = generateStep(tableInfo.number, 1);
    emit(LearnState(currentStep: 1, gameStep: step));
  }

  void selectAnswer(int answer) {
    if (!state.isIdle) return;

    final isCorrect = answer == state.gameStep.correctAnswer;

    final newStreak = isCorrect ? state.streak + 1 : 0;
    final newStars =
        isCorrect && newStreak % AppConstants.streakStarThreshold == 0
            ? state.stars + 1
            : state.stars;

    emit(state.copyWith(
      selectedAnswer: answer,
      answerStatus: isCorrect ? AnswerStatus.correct : AnswerStatus.wrong,
      streak: newStreak,
      stars: newStars,
    ));

    if (isCorrect) {
      _saveIfBetter(state.currentStep);
      _timer = Timer(
        const Duration(milliseconds: AppConstants.correctAnswerDelay),
        _advance,
      );
    } else {
      _timer = Timer(
        const Duration(milliseconds: AppConstants.wrongAnswerResetDelay),
        _resetAnswer,
      );
    }
  }

  void toggleShowAnswer() {
    if (!state.isIdle) return;
    emit(state.copyWith(showAnswer: !state.showAnswer));
  }

  void toggleShowHint() => emit(state.copyWith(showHint: !state.showHint));

  void restart() {
    _timer?.cancel();
    final step = generateStep(_tableInfo.number, 1);
    emit(LearnState(currentStep: 1, gameStep: step));
  }

  void _advance() {
    if (isClosed) return;
    final next = state.currentStep + 1;
    if (next > AppConstants.stepsPerTable) {
      emit(state.copyWith(isCompleted: true));
      return;
    }
    final step = generateStep(_tableInfo.number, next);
    emit(state.copyWith(
      currentStep: next,
      gameStep: step,
      answerStatus: AnswerStatus.idle,
      showAnswer: false,
      clearSelected: true,
    ));
  }

  void _resetAnswer() {
    if (isClosed) return;
    emit(state.copyWith(
      answerStatus: AnswerStatus.idle,
      clearSelected: true,
    ));
  }

  Future<void> _saveIfBetter(int step) async {
    await saveProgress(_tableInfo.number, step);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
