// This is our global ServiceLocator
import 'package:get_it/get_it.dart';
import 'package:strongr/app_db.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/exercise/bloc/exercise_bloc.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/data/exercise_repo.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/workout/bloc/workout_bloc.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/data/workout_repo.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workset/bloc/workset_bloc.dart';
import 'package:strongr/workset/bloc/workset_bloc_api.dart';
import 'package:strongr/workset/data/workset_repo.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';

GetIt serviceLocator = GetIt.instance;

void serviceInit() {
  //main.db
  serviceLocator.registerSingleton<AppDatabaseApi>(AppDatabase(),
      signalsReady: true);

  //repos
  serviceLocator.registerSingleton<WorkoutRepoApi>(WorkoutRepo(),
      signalsReady: true);
  serviceLocator.registerSingleton<WorkSetRepoApi>(WorkSetRepo());
  serviceLocator.registerSingleton<ExerciseRepoApi>(ExerciseRepo());

  //blocs
  serviceLocator.registerSingleton<WorkoutBlocApi>(WorkoutBloc());
  serviceLocator.registerSingleton<WorkSetBlocApi>(WorkSetBloc());
  serviceLocator.registerSingleton<ExerciseBlocApi>(ExerciseBloc());
}
