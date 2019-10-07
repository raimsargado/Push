import 'dart:async';

import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutBloc extends WorkoutBlocApi {

  var _workoutRepo = serviceLocator.get<WorkoutApi>();

  var valController = new StreamController<Workout>.broadcast();
  var valControllerOutput = new StreamController<Workout>.broadcast();

  WorkoutBloc() {
    valController.stream.listen((workout) {
      valControllerOutput.sink.add(workout);
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
