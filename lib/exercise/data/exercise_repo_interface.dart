import 'package:strongr/exercise/models/exercise.dart';

abstract class ExerciseRepoInterface {
  //get exercises
  List<Exercise> get exercises;

  //get exercise
  Exercise get exercise;

  //add exercise(Exercise)
  void addExercise(Exercise exercise);

  //update exercise(Exercise)
  void updateExercise(Exercise exercise);

  //delete exercise(Exercise)
  void deleteExercise(Exercise exercise);
}
