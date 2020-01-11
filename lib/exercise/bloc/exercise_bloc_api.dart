import 'package:strongr/app_bloc.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class ExerciseBlocApi with AppBloc {
  void initExercises(String workoutName);

  Future<Exercise> addWorkSet(Exercise exercise);

  Future<Exercise> updateWorkSet(Exercise exercise, WorkSet newWorkSet);
}
