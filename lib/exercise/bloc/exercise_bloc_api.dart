import 'package:strongr/app_bloc.dart';
import 'package:strongr/exercise/models/exercise.dart';

abstract class ExerciseBlocApi with AppBloc {
  void initExercises(String workoutName);
  void addWorkSet(Exercise exercise);
}
