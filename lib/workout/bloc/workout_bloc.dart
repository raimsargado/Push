import 'dart:async';

import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutBloc extends WorkoutBlocApi {
  var _workoutList = List<Workout>();
  var _workoutRepo = serviceLocator.get<WorkoutRepoApi>();
  var valController = new StreamController<List<Workout>>.broadcast();
  var valControllerOutput = new StreamController<List<Workout>>.broadcast();

  WorkoutBloc() {
    valController.stream.listen((workouts) {
      valControllerOutput.sink.add(workouts);
    });

    _workoutRepo.getWorkouts().then((workouts) {
      _workoutList.addAll(workouts);
      valController.sink.add(workouts);
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
    var workout = any as Workout;
    _workoutRepo.addWorkout(workout).then((_) {
      _workoutList.add(workout);
      valController.sink.add(_workoutList); //TODO DIRECT TO DB
    });
  }
}
