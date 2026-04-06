import 'package:equatable/equatable.dart';

enum QuestionType { result, multiplier, multiplicand }

class GameStep extends Equatable {
  final int tableNumber;
  final int multiplier;
  final List<int> options;
  final QuestionType type;

  const GameStep({
    required this.tableNumber,
    required this.multiplier,
    required this.options,
    this.type = QuestionType.result,
  });

  int get result => tableNumber * multiplier;

  int get correctAnswer {
    switch (type) {
      case QuestionType.result:
        return result;
      case QuestionType.multiplier:
        return multiplier;
      case QuestionType.multiplicand:
        return tableNumber;
    }
  }

  @override
  List<Object> get props => [tableNumber, multiplier, options, type];
}
