import '../entities/table_info.dart';

abstract class ProgressRepository {
  Future<int> getProgress(int tableNumber);
  Future<void> saveProgress(int tableNumber, int step);
  Future<List<TableInfo>> getAllTableInfos();
  Future<void> resetProgress(int tableNumber);
}
