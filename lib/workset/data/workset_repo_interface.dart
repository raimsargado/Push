import 'package:strongr/workset/models/workset.dart';

abstract class WorkSetRepoApi {
  //get exercises
  List<WorkSet> get workSets;

  //get WorkSet
  WorkSet get workSet;

  //add WorkSet(WorkSet)
  void addExercise(WorkSet workSet);

  //update WorkSet(WorkSet)
  void updateExercise(WorkSet workSet);

  //delete WorkSet(WorkSet)
  void deleteExercise(WorkSet workSet);
}
