import 'package:strongr/exercise/models/exercise.dart';

abstract class ExerciseRepoApi {
  //get exercises
  List<Exercise> get exercises;

  //get exercise
  Exercise get exercise;

  //add exercise(Exercise)
  Future addExercise(Exercise exercise);

  //update exercise(Exercise)
  void updateExercise(Exercise exercise);

  //delete exercise(Exercise)
  Future<dynamic> deleteExercise(Exercise exercise);

  Future<List<Exercise>> getExercises(String workoutName);

  Future<dynamic> searchExercise(Exercise exercise);

}
