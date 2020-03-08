import 'package:push/app_bloc.dart';
import 'package:push/exercise/models/exercise.dart';

abstract class WorkSetBlocApi with AppBloc {
  void initWorkSets(String workoutName, String exerciseName);
  void updateWorkSets(Exercise exercise);
}
