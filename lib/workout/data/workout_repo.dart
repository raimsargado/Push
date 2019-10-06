
import 'package:strongr/workout/data/workout_interface.dart';
import 'package:strongr/workout/models/exercise.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/models/workset.dart';
//todo
class WorkoutRepo implements WorkoutInterface {

  final workoutList = List<Workout>();

  WorkoutRepo._privateConstructor() {
//    initFirstStorage();
  }

  static final _instance = WorkoutRepo._privateConstructor();

  factory WorkoutRepo() {
    return _instance;
  }


  @override
  void addExercise(Exercise exercise) {
    // TODO: add Exercise to db
  }

  @override
  void addWorkSet(WorkSet workSet) {
    // TODO: add WorkdSEt to db
  }

  @override
  void addWorkout(Workout workout) {
    // TODO: add Workout to db

  }
}
