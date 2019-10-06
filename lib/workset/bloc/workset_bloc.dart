import 'dart:async';

import 'package:strongr/main.dart';
import 'package:strongr/workset/bloc/workset_bloc_interface.dart';
import 'package:strongr/workset/data/workset_repo_interface.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetBloc extends WorkSetBlocInterface {
  //
  var _workSetRepo = serviceLocator.get<WorkSetRepoInterface>();

  var valController = new StreamController<WorkSet>.broadcast();
  var valControllerOutput = new StreamController<WorkSet>.broadcast();

  WorkSetBloc() {
    valController.stream.listen((workset) {
      valControllerOutput.sink.add(workset);
    });
  }

  @override
  Stream<WorkSet> get valOutput => valControllerOutput.stream;

  @override
  void dispose() {
    valControllerOutput.close();
    valController.close();
  }

  @override
  void valInput(any) {
    // TODO: implement valInput
  }
}
