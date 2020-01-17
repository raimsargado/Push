import 'dart:async';

import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

class ExerciseBloc implements ExerciseBlocApi {
  //
  static const TAG = "EXERBLOC";
  var _exercises = List<Exercise>();
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

  @override
  void dispose() {
    valControllerOutput.close();
    valController.close();
  }

  @override
  void valCreate(dynamic any) {
    var exercise = any as Exercise;
    print("$TAG valcreate: ${exercise.workSets}");
    _exerciseRepo.addExercise(exercise).then((_) {
      //update exercise list and the view via stream
      _exercises.add(exercise);
      valController.sink.add(_exercises);
    });
  }

  @override
  void valDelete(any) {
    var exercise = any as Exercise;
    _exerciseRepo.deleteExercise(exercise).then((_) {
      var filteredExercise = _exercises.firstWhere((exer) => exer.name == exercise.name);
      print("filteredworkout ${filteredExercise.name}");
      print("removed workout: ${exercise.name}");
      //remove workout
      _exercises.remove(filteredExercise);
      valController.sink.add(_exercises); //update list
    });
  }

  @override
  void valUpdate(any) {
    var exer  = any as Exercise;
    _exerciseRepo.updateExercise(exer);
  }

  @override
  Future<bool> valSearch(any) async {
    var exerciseName = any as String;
    bool exists = false;
    if (_exercises.isNotEmpty) {
      var filtered = _exercises.firstWhere(
          (w) => w.name.trim() == exerciseName.trim(),
          orElse: () => null);
      exists = filtered != null;
    } else {
      exists = false;
    }

    return exists;
  }

  @override
  void initExercises(Workout workout) {
    _exerciseRepo.getExercises(workout).then((exercises) {
      //trigger stream
      _exercises.clear();
      _exercises.addAll(exercises);
      valController.sink.add(_exercises);
    });
  }

  @override
  Future<Exercise> addWorkSet(exercise) async {
    return await _exerciseRepo.addWorkSet(exercise).then((newExercise) async {
      return Future<Exercise>.value(newExercise);
    });
  }

  @override
  var outWorkSets;

  @override
  Future<Exercise> updateWorkSet(Exercise exercise, WorkSet newWorkSet) async {
    return await _exerciseRepo
        .updateWorkSet(exercise, newWorkSet)
        .then((newExercise) async {
      return Future<Exercise>.value(newExercise);
    });
  }

  @override
  void saveAllProgress() {
    _exerciseRepo.saveAllProgress();
  }
}
