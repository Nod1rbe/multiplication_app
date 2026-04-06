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
    final correct = tableNumber * multiplier;
    final Set<int> opts = {correct};

    while (opts.length < AppConstants.optionsCount) {
      final fake = tableNumber * (_rng.nextInt(10) + 1);
      if (fake != correct) opts.add(fake);
    }

    return GameStep(
      tableNumber: tableNumber,
      multiplier: multiplier,
      options: opts.toList()..shuffle(_rng),
    );
  }
}

class ResetProgressUseCase {
  final ProgressRepository repository;
  ResetProgressUseCase(this.repository);

  Future<void> call(int tableNumber) => repository.resetProgress(tableNumber);
}
