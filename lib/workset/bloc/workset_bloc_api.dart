import 'package:strongr/app_bloc.dart';
import 'package:strongr/exercise/models/exercise.dart';

abstract class WorkSetBlocApi with AppBloc {
  void initWorkSets(String workoutName, String exerciseName);
  void updateWorkSets(Exercise exercise);
}
