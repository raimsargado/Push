import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

class ExerciseBloc implements ExerciseBlocApi {
  //
  static const TAG = "EXERBLOC";
  var _exerciseRepo = serviceLocator.get<ExerciseRepoApi>();
  var valController = new StreamController<List<Exercise>>.broadcast();
  var valControllerOutput = new StreamController<List<Exercise>>.broadcast();

  ExerciseBloc() {
    valController.stream.listen((exercises) {
      valControllerOutput.sink.add(exercises);
    });
  }

  @override
  Stream get valOutput => valControllerOutput.stream;

  void dispose() {
    valControllerOutput.close();
    valController.close();
  }

  @override
  void createExercise(exercise, workout) {
//    print("$TAG valcreate: ${exercise.workSets}");
    _exerciseRepo.addExercise(exercise, workout).then((exercises) {
      valController.sink.add(null);
      Timer(Duration(milliseconds: 100), () {
        print("Yeah, this line is printed after 3 seconds");
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
        print("Yeah, this line is printed after 3 seconds");
        valController.sink.add(exercises);
      });
    });
  }

  @override
  void updateExercise(any) {
    var exer = any as Exercise;
    _exerciseRepo.updateExercise(exer);
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
      valController.sink.add(exercises);
    });
  }

  @override
  Future<Exercise> addWorkSet(exercise) async {
    return await _exerciseRepo.addWorkSet(exercise).then((newExercise) async {
      return Future<Exercise>.value(newExercise);
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
  void saveAllProgress(workout) async {
    await _exerciseRepo.saveAllProgress(workout).then((exercises) {
      valController.sink.add(null);
      Timer(Duration(milliseconds: 100), () {
        print("Yeah, this line is printed after 3 seconds");
        valController.sink.add(exercises);
      });
    });
  }
}
