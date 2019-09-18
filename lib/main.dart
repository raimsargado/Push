import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/bloc/workout_bloc.dart';
import 'package:strongr/models/workset.dart';
import 'package:strongr/views/root_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(builder: (context) => WorkoutBloc()),
        Provider(builder: (context) => WorkSetBloc()),
      ],
      child: RootView(),
    ),
  );
}

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
