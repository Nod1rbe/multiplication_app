import 'package:equatable/equatable.dart';

class GameStep extends Equatable {
  final int tableNumber;
  final int multiplier;
  final List<int> options;

  const GameStep({
    required this.tableNumber,
    required this.multiplier,
    required this.options,
  });

  int get correctAnswer => tableNumber * multiplier;

  @override
  List<Object> get props => [tableNumber, multiplier, options];
}
