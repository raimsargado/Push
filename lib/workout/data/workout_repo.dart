import 'package:push/workout/data/workout_dao.dart';
import 'package:push/workout/data/workout_repo_api.dart';
import 'package:push/workout/models/workout.dart';

class WorkoutRepo implements WorkoutRepoApi {
  //
  var dao = WorkoutDao();

  var workoutList = List<Workout>();

  WorkoutRepo() {
//    initAndGetWorkouts();
  }

  @override
  Future<int> addWorkout(Workout workout) async {
    return dao.addWorkout(workout);
  }

  @override
  Future<dynamic> deleteWorkout(Workout workOut) {
    return dao.deleteWorkout(workOut);
  }

  @override
  Future<dynamic> updateWorkout(Workout workout) async {
    return await dao.updateWorkout(workout);
  }

  @override
  Future<List<Workout>> getWorkouts() async {
    return await dao.getWorkoutsFromDao();
  }

  @override
  Future<Workout> getWorkout(String workoutKey) async {
//    return await dao.getWorkout(workoutKey);
  }

  @override
  Future<bool> searchWorkout(String workoutName) async {
    return await dao.hasWorkout(workoutName);
  }

  @override
  Future<List<Workout>> reorder(int oldIndex, int newIndex) async {
    return await dao.reorder(oldIndex,newIndex);
  }
}
