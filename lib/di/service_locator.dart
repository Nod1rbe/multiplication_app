import 'package:get_it/get_it.dart';
import 'package:multiplication_app/data/repositories/progress_repo_impl.dart';
import 'package:multiplication_app/domain/usecases/table_use_case.dart';
import 'package:multiplication_app/presentation/learn/cubit/learn_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/progress_local_datasource.dart';
import '../domain/repositories/progress_repo.dart';
import '../presentation/home/cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  sl.registerLazySingleton<ProgressLocalDataSource>(
    () => ProgressLocalDataSourceImpl(prefs: sl()),
  );

  sl.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(dataSource: sl()),
  );

  sl.registerLazySingleton(() => GetAllTablesUseCase(sl()));
  sl.registerLazySingleton(() => SaveProgressUseCase(sl()));
  sl.registerLazySingleton(() => GenerateGameStepUseCase());
  sl.registerLazySingleton(() => ResetProgressUseCase(sl()));

  sl.registerFactory(() => HomeCubit(getAllTables: sl()));
  sl.registerFactory(
    () => LearnCubit(
      saveProgress: sl(),
      generateStep: sl(),
    ),
  );
}
