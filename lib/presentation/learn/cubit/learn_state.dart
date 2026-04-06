part of 'learn_cubit.dart';

enum AnswerStatus { idle, correct, wrong }

class LearnState extends Equatable {
  final int currentStep; // 1..10
  final GameStep gameStep;
  final AnswerStatus answerStatus;
  final int? selectedAnswer;
  final int stars;
  final int streak;
  final bool showHint;
  final bool showAnswer;
  final bool isCompleted;

  const LearnState({
    required this.currentStep,
    required this.gameStep,
    this.answerStatus = AnswerStatus.idle,
    this.selectedAnswer,
    this.stars = 0,
    this.streak = 0,
    this.showHint = false,
    this.showAnswer = false,
    this.isCompleted = false,
  });

  bool get isIdle => answerStatus == AnswerStatus.idle;

  LearnState copyWith({
    int? currentStep,
    GameStep? gameStep,
    AnswerStatus? answerStatus,
    int? selectedAnswer,
    int? stars,
    int? streak,
    bool? showHint,
    bool? showAnswer,
    bool? isCompleted,
    bool clearSelected = false,
  }) {
    return LearnState(
      currentStep: currentStep ?? this.currentStep,
      gameStep: gameStep ?? this.gameStep,
      answerStatus: answerStatus ?? this.answerStatus,
      selectedAnswer:
          clearSelected ? null : (selectedAnswer ?? this.selectedAnswer),
      stars: stars ?? this.stars,
      streak: streak ?? this.streak,
      showHint: showHint ?? this.showHint,
      showAnswer: showAnswer ?? this.showAnswer,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [
        currentStep,
        gameStep,
        answerStatus,
        selectedAnswer,
        stars,
        streak,
        showHint,
        showAnswer,
        isCompleted,
      ];
}
