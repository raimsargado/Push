import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutBloc implements WorkoutBlocApi {
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
      print("workout list: $_workoutList");
      valController.sink.add(workouts);
    });
  }

  @override
  Stream get valOutput => valControllerOutput.stream;

  @override
  void valCreate(dynamic any) {
    var workout = any as Workout;
    _workoutRepo.addWorkout(workout).then((key) {
      //update view after adding workout
      print("workout bloc workout key: $key");
      workout.id = key;
      _workoutList.add(workout);
      valController.sink.add(_workoutList); //update list
    });
  }

  @override
  void valDelete(dynamic any) {
    var workout = any as Workout;
    _workoutRepo.deleteWorkout(any).then((_) {
      var filteredWorkout = _workoutList.firstWhere((w) => w.id == workout.id);
      print("filteredworkout ${filteredWorkout.name}");
      print("removed workout: ${workout.name}");
      //remove workout
      _workoutList.remove(filteredWorkout);
      valController.sink.add(_workoutList); //update list
    });
  }

  @override
  void valUpdate(dynamic any) {
    var workout = any as Workout;
    _workoutRepo.updateWorkout(workout).then((_) {
      var filteredWorkout = _workoutList.firstWhere((w) => w.id == workout.id);
      print("filteredworkout ${filteredWorkout.name}");
      print("new workout: ${workout.name}");
      //remove old workout
      _workoutList.remove(filteredWorkout);
      //add new workout
      _workoutList.add(workout);

      valController.sink.add(_workoutList); //update list
    });
  }

  @override
  Future<bool> valSearch(dynamic any) async {
    var workout = any as Workout;
    bool exists = false;
    print("workout bloc search workoutlist: ${_workoutList.length}");
    if (_workoutList.isNotEmpty) {
      _workoutList.forEach((w) {
        print("workout exists: isNotEmpty _workoutList ${w.name}");
      });
      var filtered = _workoutList.firstWhere(
          (w) => w.name.trim() == workout.name.trim(),
          orElse: () => null);
      exists = filtered != null;
      print("workout exists: isNotEmpty $exists");
      print("workout exists: filtered ${filtered}");
    } else {
      exists = false;
      print("workout exists: $exists");
    }

    return exists;
  }

  @override
  void dispose() {
    valControllerOutput.close();
    valController.close();
  }
}
