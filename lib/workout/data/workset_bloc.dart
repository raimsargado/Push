import 'dart:async';

import 'package:strongr/workout/models/workset.dart';

class WorkSetBloc {

  var valController = new StreamController<WorkSet>.broadcast();
  var valControllerOutput = new StreamController<WorkSet>.broadcast();

  Stream<WorkSet> get valOutput => valControllerOutput.stream;

  WorkSetBloc() {
    valController.stream.listen((workset) {
      valControllerOutput.sink.add(workset);
    });
  }

  void dispose() {
    valControllerOutput.close();
    valController.close();
  }
}
