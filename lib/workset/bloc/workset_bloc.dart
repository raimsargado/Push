import 'dart:async';

import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/main.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workset/bloc/workset_bloc_api.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetBloc extends WorkSetBlocApi {
  //
  //
  var _exercise = Exercise;
  var _workSetRepo = serviceLocator.get<WorkSetRepoApi>();
  var valController = new StreamController<Exercise>.broadcast();
  var valControllerOutput = new StreamController<Exercise>.broadcast();

  var TAG = "WORKSETBLOC";

  WorkSetBloc() {
    valController.stream.listen((exercise) {
//      print("$TAG worksets ${exercise?.workSets.length}");
      valControllerOutput.sink.add(exercise);
    });
  }

  @override
  Stream get valOutput => valControllerOutput.stream;

  @override
  void dispose() {
    valControllerOutput.close();
    valController.close();
  }

  @override
  void valCreate(dynamic any) {
    var workSet = any as WorkSet;
//    _workSetRepo.addWorkSet(workSet).then((_) {
      //update exercise list and the view via stream
//      _exercise.add(workSet);
//      valController.sink.add(_exercise);
//    });
  }

  @override
  void valDelete(any) {
    // TODO: implement valDelete
  }

  @override
  void valUpdate(any) {
    var workSet = any as WorkSet;
    _workSetRepo.updateWorkSet(workSet);
  }

  @override
  Future<bool> valSearch(any) async {
    var workSet = any as WorkSet;
    bool isExist = await _workSetRepo.searchWorkSet(workSet);
    return isExist;
  }

  @override
  void initWorkSets(String workoutName, String exerciseName) {

  }

  @override
  void updateWorkSets(Exercise exercise) {
    valController.sink.add(exercise);
  }
}
