import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';

abstract class ProgressLocalDataSource {
  Future<int> getProgress(int tableNumber);
  Future<void> saveProgress(int tableNumber, int step);
  Future<void> resetProgress(int tableNumber);
}

class ProgressLocalDataSourceImpl implements ProgressLocalDataSource {
  final SharedPreferences prefs;

  ProgressLocalDataSourceImpl({required this.prefs});

  String _key(int tableNumber) => '${AppConstants.prefPrefix}$tableNumber';

  @override
  Future<int> getProgress(int tableNumber) async =>
      prefs.getInt(_key(tableNumber)) ?? 0;

  @override
  Future<void> saveProgress(int tableNumber, int step) async {
    final existing = prefs.getInt(_key(tableNumber)) ?? 0;
    if (step > existing) {
      await prefs.setInt(_key(tableNumber), step);
    }
  }

  @override
  Future<void> resetProgress(int tableNumber) async =>
      await prefs.remove(_key(tableNumber));
}
