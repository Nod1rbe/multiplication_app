import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multiplication_app/domain/usecases/table_use_case.dart';

import '../../../domain/entities/table_info.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetAllTablesUseCase getAllTables;

  HomeCubit({required this.getAllTables}) : super(HomeInitial());

  Future<void> loadTables() async {
    emit(HomeLoading());
    try {
      final tables = await getAllTables();
      emit(HomeLoaded(tables));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void refreshTable(int tableNumber, int newProgress) {
    final current = state;
    if (current is HomeLoaded) {
      final updated = current.tables.map((t) {
        return t.number == tableNumber ? t.copyWith(progress: newProgress) : t;
      }).toList();
      emit(HomeLoaded(updated));
    }
  }
}
