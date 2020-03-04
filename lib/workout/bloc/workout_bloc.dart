import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutBloc implements WorkoutBlocApi {
  var _workoutList = List<Workout>();
  var TAG = "WorkoutBloc";
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

//todo fix the sortids every after delete
  //todo or... increment the highest sortid then add the workout
  @override
  Stream get valOutput => valControllerOutput.stream;

  @override
  void valCreate(dynamic any) {
    var workout = any as Workout;
    var workoutToPush = Workout(workout.name, workout.startTime,
        _workoutList.isNotEmpty ? _workoutList.length : 0);
    _workoutRepo.addWorkout(workoutToPush).then((key) {
      //update view after adding workout
      print("workout bloc workout key: $key");
      workoutToPush.id = key;
      _workoutList.add(workoutToPush);
      valController.sink.add(_workoutList); //update list
    });
  }

  @override
  void valDelete(dynamic any) {
    var workout = any as Workout;
    _workoutRepo.deleteWorkout(workout).then((workouts) {
      _workoutList.clear();
      _workoutList.addAll(workouts);
      valController.sink.add(_workoutList); //update list
    });
  }

  @override
  void valUpdate(dynamic any) {
    var workout = any as Workout;
    print("$TAG, valUpdate : WORKOUT : ${workout.toMap()}");
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
    var workoutName = any as String;
    bool exists = false;
    print("workout bloc search workoutlist: ${_workoutList.length}");
    if (_workoutList.isNotEmpty) {
      _workoutList.forEach((w) {
        print("workout exists: isNotEmpty _workoutList ${w.name}");
      });
      var filtered = _workoutList.firstWhere(
          (w) => w.name.trim() == workoutName.trim(),
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

  @override
  void reorder(int oldIndex, int newIndex) {
    _workoutRepo.reorder(oldIndex, newIndex).then((workouts) {
      _workoutList.clear();
      _workoutList.addAll(workouts);
      valController.sink.add(_workoutList);
    });
  }
}
