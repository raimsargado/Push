import 'dart:async';

import 'package:strongr/bloc/app_bloc.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutBloc extends AppBloc {
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
