import 'dart:async';
//TODO START DOING THE DESIGN
//TODO RENAME THE APP TO "PUSH"
import 'package:flutter/material.dart';
import 'package:push/exercise/bloc/exercise_bloc_api.dart';
import 'package:push/exercise/data/exercise_repo_api.dart';
import 'package:push/exercise/models/exercise.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workset/models/workset.dart';

class ExerciseBloc implements ExerciseBlocApi {
  //
  static const TAG = "EXERBLOC";
  var _exerciseRepo = serviceLocator.get<ExerciseRepoApi>();
  var valController = new StreamController<List<Exercise>>.broadcast();
  var valControllerWithoutRefresh =
      new StreamController<List<Exercise>>.broadcast();
  var valControllerOutput = new StreamController<List<Exercise>>.broadcast();
  var valControllerOutputWithoutRefresh =
      new StreamController<List<Exercise>>.broadcast();
  var _exercises = List<Exercise>();

  ExerciseBloc() {
    valController.stream.listen((exercises) {
      valControllerOutput.sink.add(exercises);
    });

    valControllerWithoutRefresh.stream.listen((exercises) {
      valControllerOutputWithoutRefresh.sink.add(exercises);
    });
  }

  @override
  Stream get valOutput => valControllerOutput.stream;

  @override
  Stream get valOutputWithoutRefresh =>
      valControllerOutputWithoutRefresh.stream;

  void dispose() {
    //
    valController.close();
    valControllerOutput.close();
    //
    valControllerWithoutRefresh.close();
    valControllerOutputWithoutRefresh.close();
  }

  @override
  void createExercise(exercise, workout) {
//    print("$TAG valcreate: ${exercise.workSets}");
    _exerciseRepo.addExercise(exercise, workout).then((exercises) {
      valController.sink.add(null);
      Timer(Duration(milliseconds: 100), () {
        valController.sink.add(exercises);
      });
    });
  }

  @override
  void deleteExercise(any, workout) {
    var exercise = any as Exercise;
    _exerciseRepo.deleteExercise(exercise, workout).then((exercises) {
      valController.sink.add(null);
      Timer(Duration(milliseconds: 100), () {
        valController.sink.add(exercises);
      });
    });
  }

  @override
  void updateExercise(any, workout) {
    var exer = any as Exercise;
    _exerciseRepo.updateExercise(exer, workout).then((exercises) {
      valController.sink.add(exercises);
    });
  }

  @override
  Future<bool> searchExercise(exerciseName) async {
    return await _exerciseRepo.searchExercise(exerciseName).then((isExisting) {
      return isExisting;
    });
  }

  @override
  void initExercises(Workout workout) {
    _exerciseRepo.getExercises(workout).then((exercises) {
      //trigger stream
      _exercises.clear();
      _exercises.addAll(exercises);
      valController.sink.add(_exercises);
      valControllerWithoutRefresh.sink.add(_exercises);
    });
  }

  @override
  void addWorkSet(exercise, workout) async {
    return await _exerciseRepo
        .addWorkSet(exercise, workout)
        .then((newExercises) async {
      //push new list
      valController.sink.add(newExercises); //clear the pipe
    });
  }

  @override
  void updateWorkSet(
      Exercise exercise, WorkSet newWorkSet, Workout workout) async {
    await _exerciseRepo
        .updateWorkSet(exercise, newWorkSet, workout)
        .then((newExercises) {
      //push new list
      valController.sink.add(newExercises);
    });
  }

  @override
  void deleteWorkSet(
      Exercise exercise, WorkSet workSetToRemove, Workout workout) async {
    await _exerciseRepo
        .deleteWorkSet(exercise, workSetToRemove, workout)
        .then((newExercises) {
      valController.sink.add(newExercises);
    });
  }

  @override
  void saveAllProgress(workout) async {
    await _exerciseRepo.saveAllProgress(workout).then((exercises) {
      valController.sink.add(null); //clear the pipe
      Timer(Duration(milliseconds: 100), () {
        valController.sink.add(exercises);
      });
    });
  }

  @override
  void reorder(int oldIndex, int newIndex, workout) {
    print("$TAG reorder");
    _exerciseRepo.reorder(oldIndex, newIndex, workout).then((exercises) {
      //update the reorder view
      _exercises.clear();
      _exercises.addAll(exercises);
      valControllerWithoutRefresh.sink.add(_exercises);
      //update the workout view
      valController.sink.add(null);
      Timer(Duration(milliseconds: 100), () {
        valController.sink.add(_exercises);
      });
    });
  }
}
