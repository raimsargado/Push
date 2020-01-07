import 'dart:async';

import 'package:strongr/main.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workset/bloc/workset_bloc_api.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetBloc extends WorkSetBlocApi {
  //
  //
  var _workSets = List<WorkSet>();
  var _workSetRepo = serviceLocator.get<WorkSetRepoApi>();
  var valController = new StreamController<List<WorkSet>>.broadcast();
  var valControllerOutput = new StreamController<List<WorkSet>>.broadcast();

  var TAG = "WORKSETBLOC";

  WorkSetBloc() {
    valController.stream.listen((workSets) {
      print("$TAG worksets ${workSets.length}");
      valControllerOutput.sink.add(workSets);
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
    _workSetRepo.addWorkSet(workSet).then((_) {
      //update exercise list and the view via stream
      _workSets.add(workSet);
      valController.sink.add(_workSets);
    });
  }

  @override
  void valDelete(any) {
    // TODO: implement valDelete
  }

  @override
  void valUpdate(any) {
    // TODO: implement valUpdate
  }

  @override
  Future<bool> valSearch(any) async {
    var workSet = any as WorkSet;
    bool isExist = await _workSetRepo.searchWorkSet(workSet);
    return isExist;
  }

  @override
  void initWorkSets(String workoutName, String exerciseName) {
    _workSetRepo.getWorkSets(workoutName, exerciseName).then((workSets) {
      //trigger stream
      _workSets.clear();
      _workSets.addAll(workSets);
      _workSets.forEach((ws) {
        print("initWorkSets exerciseName: $exerciseName worksets item:  ${ws.id}");
      });
      print("initWorkSets worksets ${_workSets.length}");
      valController.sink.add(_workSets);
    });
  }

  @override
  void updateWorkSets(List<WorkSet> workSets) {
    valController.sink.add(workSets);
  }
}
