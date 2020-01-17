import 'package:strongr/app_bloc.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class ExerciseBlocApi with AppBloc {
  void initExercises(Workout workout);

  Future<Exercise> addWorkSet(Exercise exercise);

  Future<Exercise> updateWorkSet(Exercise exercise, WorkSet newWorkSet);

  Future<void> saveAllProgress();
}
