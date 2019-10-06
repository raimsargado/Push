import 'package:strongr/workout/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/models/workset.dart';

abstract class WorkoutDaoInterface {
  //get workouts
  List<Workout> get workouts;

  //get exercises
  List<Exercise> get exercises;

  //get sets
  List<WorkSet> get workSets;

  //add workout(Workout)
  void addWorkout(Workout workout);

  //add exercise(Exercise)
  void addExercise(Exercise exercise);

  //add workSet(WorkSet)
  void addWorkSet(WorkSet workSet);

  //update workout(Workout)
  void updateWorkout(Workout workout);

  //update exercise(Exercise)
  void updateExercise(Exercise exercise);

  //update workSet(WorkSet)
  void updateSet(WorkSet workSet);

  //delete workout(Workout)
  void deleteWorkout(Workout workOut);

  //delete exercise(Exercise)
  void deleteExercise(Exercise exercise);

  //delete workSet(WorkSet)
  void deleteWorkSet(WorkSet workSet);
}
