import 'package:strongr/app_bloc.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class WorkSetBlocApi with AppBloc {
  void initWorkSets(String workoutName, String exerciseName);
  void updateWorkSets(List<WorkSet> workSets);
}
