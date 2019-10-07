import 'dart:async';

import 'package:strongr/main.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_interface.dart';
import 'package:strongr/workout/data/workout_repo_interface.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutBloc extends WorkoutBlocInterface {

  var _workoutRepo = serviceLocator.get<WorkoutRepoInterface>();

  var valController = new StreamController<Workout>.broadcast();
  var valControllerOutput = new StreamController<Workout>.broadcast();

  WorkoutBloc() {
    valController.stream.listen((exercise) {
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
  void valInput(dynamic any) {
    valController.sink
        .add(Workout("Leg Day", any));
  }

}
