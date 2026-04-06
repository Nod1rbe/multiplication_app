import 'dart:math';

import 'package:multiplication_app/domain/repositories/progress_repo.dart';

import '../../core/constants/app_constants.dart';
import '../entities/game_step.dart';
import '../entities/table_info.dart';

class GetAllTablesUseCase {
  final ProgressRepository repository;
  GetAllTablesUseCase(this.repository);

  Future<List<TableInfo>> call() => repository.getAllTableInfos();
}

class SaveProgressUseCase {
  final ProgressRepository repository;
  SaveProgressUseCase(this.repository);

  Future<void> call(int tableNumber, int step) =>
      repository.saveProgress(tableNumber, step);
}

class GenerateGameStepUseCase {
  final Random _rng = Random();

  GameStep call(int tableNumber, int multiplier) {
    // Randomly choose question type
    final type = QuestionType.values[_rng.nextInt(QuestionType.values.length)];
    
    int correct;
    Set<int> opts;

    switch (type) {
      case QuestionType.result:
        correct = tableNumber * multiplier;
        opts = {correct};
        while (opts.length < AppConstants.optionsCount) {
          final fake = tableNumber * (_rng.nextInt(10) + 1);
          opts.add(fake);
        }
        break;
      case QuestionType.multiplier:
        correct = multiplier;
        opts = {correct};
        while (opts.length < AppConstants.optionsCount) {
          final fake = _rng.nextInt(10) + 1;
          opts.add(fake);
        }
        break;
      case QuestionType.multiplicand:
        correct = tableNumber;
        opts = {correct};
        while (opts.length < AppConstants.optionsCount) {
          final fake = _rng.nextInt(10) + 1;
          opts.add(fake);
        }
        break;
    }

    return GameStep(
      tableNumber: tableNumber,
      multiplier: multiplier,
      type: type,
      options: opts.toList()..shuffle(_rng),
    );
  }
}

class ResetProgressUseCase {
  final ProgressRepository repository;
  ResetProgressUseCase(this.repository);

  Future<void> call(int tableNumber) => repository.resetProgress(tableNumber);
}
