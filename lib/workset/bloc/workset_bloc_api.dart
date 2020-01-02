import 'package:strongr/app_bloc.dart';

abstract class WorkSetBlocApi with AppBloc {
  void initWorkSets(String workoutName, String exerciseName);
}
