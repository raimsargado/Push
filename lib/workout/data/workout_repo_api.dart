import 'package:push/exercise/models/exercise.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workset/models/workset.dart';

abstract class WorkoutRepoApi {
  //get workouts
  Future<List<Workout>> getWorkouts();

  //get workout
  Future<Workout> getWorkout(String workoutKey);

  //add workout(Workout)
  Future<dynamic> addWorkout(Workout workout);

  //update workout(Workout)
  Future<dynamic> updateWorkout(Workout workout);

  //delete workout(Workout)
  Future<dynamic> deleteWorkout(Workout workOut);

  Future<dynamic> searchWorkout(String workoutName);

  Future<List<Workout>> reorder(int oldIndex, int newIndex);
}
