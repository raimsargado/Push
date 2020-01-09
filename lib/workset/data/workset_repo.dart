import 'package:strongr/workset/data/workset_dao.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetRepo extends WorkSetRepoApi {
  var dao = WorkSetDao();

  @override
  Future addWorkSet(WorkSet workSet) async {
    await dao.addWorkSet(workSet);
  }

  @override
  void deleteWorkSet(WorkSet workSet) {
    // TODO: implement deleteExercise
  }

  @override
  void updateWorkSet(WorkSet workSet) {
   dao.updateSet(workSet);
  }

  @override
  // TODO: implement workSet
  WorkSet get workSet => null;

  @override
  // TODO: implement workSets
  List<WorkSet> get workSets => null;

  @override
  Future<List<WorkSet>> getWorkSets(String workoutName, String exerciseName) async {
    var exercises = await dao.getWorkSets(workoutName,exerciseName);
    return exercises;
  }

  @override
  Future<bool> searchWorkSet(WorkSet exercise) {
    // TODO: implement searchExercise
    return null;
  }
}
