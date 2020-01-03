import 'dart:async';

import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';

class ExerciseBloc implements ExerciseBlocApi {
  //
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
      var filteredExercise = _exercises.firstWhere((w) => w.id == exercise.id);
      print("filteredworkout ${filteredExercise.name}");
      print("removed workout: ${exercise.name}");
      //remove workout
      _exercises.remove(filteredExercise);
      valController.sink.add(_exercises); //update list
    });
  }

  @override
  void valUpdate(any) {
    // TODO: implement valUpdate
  }

  @override
  Future<bool> valSearch(any) async {
    var exercise = any as Exercise;
    bool exists = false;
    if (_exercises.isNotEmpty) {
      var filtered = _exercises.firstWhere(
          (w) => w.name.trim() == exercise.name.trim(),
          orElse: () => null);
      exists = filtered != null;
    } else {
      exists = false;
    }

    return exists;
  }

  @override
  void initExercises(String workoutName) {
    _exerciseRepo.getExercises(workoutName).then((exercises) {
      //trigger stream
      _exercises.clear();
      _exercises.addAll(exercises);
      valController.sink.add(_exercises);
    });
  }
}
