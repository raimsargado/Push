import 'dart:async';

import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';

class ExerciseBloc extends ExerciseBlocApi {
  var _exerciseRepo = serviceLocator.get<ExerciseRepoApi>();

  var valController = new StreamController<Exercise>.broadcast();
  var valControllerOutput = new StreamController<Exercise>.broadcast();

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
    valController.sink.add(Exercise("Leg Day"));
  }
}
