import 'package:strongr/workout/data/workout_dao.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';


class WorkoutRepo implements WorkoutApi {

  var dao = WorkoutDao();

  final workoutList = List<Workout>();

  WorkoutRepo._privateConstructor() {
//    initFirstStorage();
  }

  static final _instance = WorkoutRepo._privateConstructor();

  factory WorkoutRepo() {
    return _instance;
  }

  @override
  void addWorkout(Workout workout) {
    // TODO: implement addWorkout
  }

  @override
  void deleteWorkout(Workout workOut) {
    // TODO: implement deleteWorkout
  }

  @override
  void updateWorkout(Workout workout) {
    // TODO: implement updateWorkout
  }

  @override
  // TODO: implement workout
  Workout get workout => null;

  @override
  // TODO: implement workouts
  List<Workout> get workouts => null;

}
