import 'package:strongr/workset/models/workset.dart';

abstract class WorkSetRepoApi {
  //get exercises
  List<WorkSet> get workSets;

  //get WorkSet
  WorkSet get workSet;

  //add WorkSet(WorkSet)
  Future addWorkSet(WorkSet workSet);

  //update WorkSet(WorkSet)
  void updateWorkSet(WorkSet workSet);

  //delete WorkSet(WorkSet)
  void deleteWorkSet(WorkSet workSet);

  Future<bool> searchWorkSet(WorkSet workSet);

  Future<List<WorkSet>> getWorkSets(String workoutName, String exerciseName);
}
