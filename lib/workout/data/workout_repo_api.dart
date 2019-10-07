import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

abstract class WorkoutApi {
  //get workouts
  List<Workout> get workouts;

  //get workout
  Workout get workout;

  //add workout(Workout)
  void addWorkout(Workout workout);

  //update workout(Workout)
  void updateWorkout(Workout workout);

  //delete workout(Workout)
  void deleteWorkout(Workout workOut);
}
