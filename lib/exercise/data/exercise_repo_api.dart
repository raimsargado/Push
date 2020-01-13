import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class ExerciseRepoApi {
  //get exercises
  List<Exercise> get exercises;

  //get exercise
  Future<Exercise> getExercise(exercise);

  //add exercise(Exercise)
  Future addExercise(Exercise exercise);

  //update exercise(Exercise)
  void updateExercise(Exercise exercise);

  //delete exercise(Exercise)
  Future<dynamic> deleteExercise(Exercise exercise);

  Future<List<Exercise>> getExercises(Workout workout);

  Future<dynamic> searchExercise(Exercise exercise);

  Future<Exercise> addWorkSet(Exercise exercise);

  Future<Exercise> updateWorkSet(Exercise exercise,WorkSet newWorkSet);

  List<WorkSet> getWorkSets(Exercise exercise);


}
