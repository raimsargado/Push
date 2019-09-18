import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/models/exercise.dart';
import 'package:strongr/root_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          builder: (context) => ExerciseBloc(),
        )
      ],
      child: RootView(),
    ),
  );
}

class ExerciseBloc {
  var valController = new StreamController<Exercise>();
  var valControllerOutput = new StreamController<Exercise>();

  Stream<Exercise> get exerciseOutput => valControllerOutput.stream;

  ExerciseBloc() {
    valController.stream.listen((exercise) {
      valControllerOutput.sink.add(exercise);
    });
  }

  void dispose() {
    valControllerOutput.close();
    valController.close();
  }
}
