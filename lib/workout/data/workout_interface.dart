import 'package:strongr/workout/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/models/workset.dart';

abstract class WorkoutInterface {
  void addWorkout(Workout workout);

  void addExercise(Exercise exercise);

  void addWorkSet(WorkSet workSet);
}
