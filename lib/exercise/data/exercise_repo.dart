import 'package:strongr/exercise/data/exercise_dao.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

class ExerciseRepo implements ExerciseRepoApi {
  var dao = ExerciseDao();

  @override
  Future<dynamic> addExercise(Exercise exercise, Workout workout) async {
    return await dao.addExercise(exercise, workout);
  }

  @override
  Future<dynamic> deleteExercise(Exercise exercise, Workout workout) async {
    return await dao.deleteExercise(exercise, workout);
  }

  @override
  Exercise get exercise => null;

  @override
  List<Exercise> get exercises => null;

  @override
  Future<dynamic> updateExercise(Exercise exercise, Workout workout) async {
    return await dao.updateExercise(exercise,workout);
  }

  @override
  Future<List<Exercise>> getExercises(Workout workout) async {
    var exercises = await dao.getExercises(workout);
    return exercises;
  }

  @override
  Future<bool> searchExercise(exerciseName) async {
    return await dao.hasExercise(exerciseName);
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
  Future<List<Exercise>> updateWorkSet(
      Exercise exercise, WorkSet newWorkSet, Workout workout) async {
    return await dao.updateWorkSet(exercise, newWorkSet, workout);
  }


  Future<List<Exercise>> deleteWorkSet(
      Exercise exercise, WorkSet newWorkSet, Workout workout) async {
    return await dao.deleteWorkSet(exercise, newWorkSet, workout);
  }

  @override
  Future<Exercise> saveExerciseProgress(Exercise exercise) async {
    return await dao.saveExerciseProgress(exercise);
  }

  @override
  Future saveAllProgress(Workout workout) async {
    return await dao.saveAllProgress(workout);
  }
}
