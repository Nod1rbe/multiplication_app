import 'package:multiplication_app/domain/repositories/progress_repo.dart';

import '../../core/constants/app_constants.dart';
import '../../domain/entities/table_info.dart';
import '../datasources/progress_local_datasource.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressLocalDataSource dataSource;

  ProgressRepositoryImpl({required this.dataSource});

  @override
  Future<int> getProgress(int tableNumber) =>
      dataSource.getProgress(tableNumber);

  @override
  Future<void> saveProgress(int tableNumber, int step) =>
      dataSource.saveProgress(tableNumber, step);

  @override
  Future<List<TableInfo>> getAllTableInfos() async {
    final tables = <TableInfo>[];
    for (int n = AppConstants.tableMin; n <= AppConstants.tableMax; n++) {
      final progress = await dataSource.getProgress(n);
      tables.add(TableInfo(number: n, progress: progress));
    }
    return tables;
  }

  @override
  Future<void> resetProgress(int tableNumber) =>
      dataSource.resetProgress(tableNumber);
}
