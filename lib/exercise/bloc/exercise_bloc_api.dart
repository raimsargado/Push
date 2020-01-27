import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class ExerciseBlocApi {
  void initExercises(Workout workout);

  Future<Exercise> addWorkSet(Exercise exercise);

  Stream<dynamic> get valOutput;

  void updateWorkSet(Exercise exercise, WorkSet newWorkSet, Workout workout);

  Future<Exercise>  deleteWorkSet(Exercise exercise, WorkSet workSetToRemove, Workout workout);

  void deleteExercise(any, workout);

  void saveAllProgress(Workout workout);

  void createExercise(any, workout);

  void updateExercise(dynamic any, Workout workout);

  Future<bool> searchExercise(exerciseName);
}
