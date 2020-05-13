// This is our global ServiceLocator
import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:push/app_db.dart';
import 'package:push/app_db_interface.dart';
import 'package:push/exercise/bloc/exercise_bloc.dart';
import 'package:push/exercise/bloc/exercise_bloc_api.dart';
import 'package:push/exercise/data/exercise_repo.dart';
import 'package:push/exercise/data/exercise_repo_api.dart';
import 'package:push/workout/bloc/workout_bloc.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:push/workout/data/workout_repo.dart';
import 'package:push/workout/data/workout_repo_api.dart';
import 'package:push/workset/bloc/workset_bloc.dart';
import 'package:push/workset/bloc/workset_bloc_api.dart';
import 'package:push/workset/data/workset_repo.dart';
import 'package:push/workset/data/workset_repo_interface.dart';

GetIt serviceLocator = GetIt.instance;
//Completer<void> locatorReady = Completer<void>();

void serviceInit() {
  //main.db
  serviceLocator.registerSingleton<AppDatabaseApi>(AppDatabase());

  //repos
  serviceLocator.registerSingleton<WorkoutRepoApi>(WorkoutRepo());
  serviceLocator.registerSingleton<WorkSetRepoApi>(WorkSetRepo());
  serviceLocator.registerSingleton<ExerciseRepoApi>(ExerciseRepo());

  //blocs
  serviceLocator.registerSingleton<WorkoutBlocApi>(WorkoutBloc(),
      signalsReady: true);
  serviceLocator.registerSingleton<WorkSetBlocApi>(WorkSetBloc());
  serviceLocator.registerSingleton<ExerciseBlocApi>(ExerciseBloc());

//  serviceLocator.ready.listen((_) {
//    locatorReady.complete();
//  });
}
