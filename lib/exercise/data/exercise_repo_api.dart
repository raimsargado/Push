import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class ExerciseRepoApi {
  //get exercises
  List<Exercise> get exercises;

  //get exercise
  Future<Exercise> getExercise(exercise);

  //add exercise(Exercise)
  Future addExercise(Exercise exercise, Workout workout);

  //update exercise(Exercise)
  Future<dynamic> updateExercise(Exercise exercise, Workout workout);

  //delete exercise(Exercise)
  Future<dynamic> deleteExercise(Exercise exercise, Workout workout);

  Future<List<Exercise>> getExercises(Workout workout);

  Future<dynamic> searchExercise(String exerciseName);

  Future<List<Exercise>> addWorkSet(Exercise exercise, Workout workout);

  Future<List<Exercise>> updateWorkSet(
      Exercise exercise, WorkSet newWorkSet, Workout workout);

  Future<List<Exercise>> deleteWorkSet(
      Exercise exercise, WorkSet newWorkSet, Workout workout);

  List<WorkSet> getWorkSets(Exercise exercise);

  Future<Exercise> saveExerciseProgress(Exercise exer);

  Future<dynamic> saveAllProgress(Workout workout);

  Future<List<Exercise>> reorder(int oldIndex, int newIndex, List<Exercise> exercises, Workout workout);
}
