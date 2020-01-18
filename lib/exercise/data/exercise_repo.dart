import 'package:strongr/exercise/data/exercise_dao.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

class ExerciseRepo implements ExerciseRepoApi {
  var dao = ExerciseDao();

  @override
  Future addExercise(Exercise exercise) async {
    await dao.addExercise(exercise);
  }

  @override
  Future<dynamic> deleteExercise(Exercise exercise) {
    return dao.deleteExercise(exercise);
  }

  @override
  Exercise get exercise => null;

  @override
  List<Exercise> get exercises => null;

  @override
  void updateExercise(Exercise exercise) {
    dao.updateExercise(exercise);
  }

  @override
  Future<List<Exercise>> getExercises(Workout workout) async {
    var exercises = await dao.getExercises(workout);
    return exercises;
  }

  @override
  Future searchExercise(Exercise exercise) async {
    return await dao.hasExercise(exercise);
  }

  @override
  Future<Exercise> addWorkSet(exercise) async {
    return await dao.addWorkSet(exercise);
  }

  @override
  Future<Exercise> getExercise(exercise) async {
    return await dao.getExercise(exercise);
  }

  @override
  List<WorkSet> getWorkSets(Exercise exercise) {
    return exercise.workSets;
  }

  @override
  Future<Exercise> updateWorkSet(Exercise exercise,WorkSet newWorkSet) async {
    return await dao.updateWorkSet(exercise,newWorkSet);
  }

  @override
  Future<Exercise> saveExerciseProgress(Exercise exercise) async {
    return await dao.saveExerciseProgress(exercise);
  }
}
