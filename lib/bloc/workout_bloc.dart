import 'dart:async';

import 'package:strongr/models/workout.dart';

class WorkoutBloc {
  var valController = new StreamController<Workout>.broadcast();
  var valControllerOutput = new StreamController<Workout>.broadcast();

  Stream<Workout> get valOutput => valControllerOutput.stream;

  WorkoutBloc() {
    valController.stream.listen((exercise) {
      valControllerOutput.sink.add(exercise);
    });
  }

  void dispose() {
    valControllerOutput.close();
    valController.close();
  }
}
