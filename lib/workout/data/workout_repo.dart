import 'package:strongr/workout/data/workout_dao.dart';
import 'package:strongr/workout/data/workout_repo_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutRepo implements WorkoutRepoApi {
  var dao = WorkoutDao();

  var workoutList = List<Workout>();

  WorkoutRepo() {
    initFirstStorage();
  }

  @override
  Future<Workout> addWorkout(Workout workout) async {
    return dao.addWorkout(workout);
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
  // TODO: implement workouts
  Future<List<dynamic>> get workouts async {
    return initFirstStorage();
  }

  Future<List<dynamic>> initFirstStorage() async {
    return await dao.workouts;
  }

  @override
 Future<Workout>  getWorkout(String workoutKey) async {
    return await dao.getWorkout(workoutKey);
  }
}
