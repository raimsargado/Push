import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:strongr/db/app_db.dart';
import 'package:strongr/db/app_db_interface.dart';
import 'package:strongr/exercise/bloc/exercise_bloc.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_interface.dart';
import 'package:strongr/exercise/data/exercise_repo.dart';
import 'package:strongr/exercise/data/exercise_repo_interface.dart';
import 'package:strongr/root_view.dart';
import 'package:strongr/workout/bloc/workout_bloc.dart';
import 'package:strongr/workout/bloc/workout_bloc_interface.dart';
import 'package:strongr/workout/data/workout_repo.dart';
import 'package:strongr/workout/data/workout_repo_interface.dart';
import 'package:strongr/workset/bloc/workset_bloc.dart';
import 'package:strongr/workset/bloc/workset_bloc_interface.dart';
import 'package:strongr/workset/data/workset_repo.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';

// This is our global ServiceLocator
GetIt serviceLocator = GetIt.instance;

void main() {

  //db
  serviceLocator.registerSingleton<AppDatabaseInterface>(AppDatabase(),
      signalsReady: true);

  //repos
  serviceLocator.registerSingleton<WorkoutRepoInterface>(WorkoutRepo());
  serviceLocator.registerSingleton<WorkSetRepoInterface>(WorkSetRepo());
  serviceLocator.registerSingleton<ExerciseRepoInterface>(ExerciseRepo());

  //blocs
  serviceLocator.registerSingleton<WorkoutBlocInterface>(WorkoutBloc());
  serviceLocator.registerSingleton<WorkSetBlocInterface>(WorkSetBloc());
  serviceLocator.registerSingleton<ExerciseBlocInterface>(ExerciseBloc());

  runApp(
    MultiProvider(
      providers: [
        Provider(builder: (context) => WorkoutBloc()),
        Provider(builder: (context) => WorkSetBloc()),
      ],
      child: RootView(),
    ),
  );
}
