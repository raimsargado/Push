import 'package:strongr/workout/data/workout_dao.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutRepo implements WorkoutRepoApi {
  //
  var dao = WorkoutDao();

  var workoutList = List<Workout>();

  WorkoutRepo() {
//    initAndGetWorkouts();
  }

  @override
  Future<dynamic> addWorkout(Workout workout) async {
    return dao.addWorkout(workout);
  }

  @override
  Future<dynamic> deleteWorkout(Workout workOut) {
    return dao.deleteWorkout(workOut);
  }

  @override
  Future<dynamic> updateWorkout(Workout workout) async {
    return await dao.update(workout);
  }

  @override
  // TODO: implement workouts
  Future<List<Workout>> getWorkouts() async {
    return await dao.getWorkoutsFromDao();
  }

  @override
  Future<Workout> getWorkout(String workoutKey) async {
//    return await dao.getWorkout(workoutKey);
  }

  @override
  Future<bool> searchWorkout(Workout workout) async {
    // TODO: implement searchWorkout
    return await dao.hasWorkout(workout);
  }
}
