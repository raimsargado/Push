import 'package:strongr/workset/data/workset_dao.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetRepo extends WorkSetRepoApi {

  var dao = WorkSetDao();

  @override
  void addExercise(WorkSet workSet) {
    // TODO: implement addExercise
  }

  @override
  void deleteExercise(WorkSet workSet) {
    // TODO: implement deleteExercise
  }

  @override
  void updateExercise(WorkSet workSet) {
    // TODO: implement updateExercise
  }

  @override
  // TODO: implement workSet
  WorkSet get workSet => null;

  @override
  // TODO: implement workSets
  List<WorkSet> get workSets => null;
}
