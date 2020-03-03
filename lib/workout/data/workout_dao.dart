import 'package:sembast/sembast.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/exercise/data/exercise_dao.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutDao {
  //
  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;
  var _exerdao = ExerciseDao();

  //workout_store
  //exercise_store
  //workSet_store

  static const String WORKOUT_STORE_NAME = 'WORKOUTS';
  static const String TAG = 'WorkoutDao';
  final _newWorkoutStore = intMapStoreFactory.store(WORKOUT_STORE_NAME);

  Future<int> addWorkout(Workout workout) async {
    //returns the key
    return await _newWorkoutStore.add(await _database, workout.toMap());
  }

  Future updateWorkout(Workout workout) async {
    print("$TAG, updateworkout: ${workout.toMap()}");
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(workout.id));
    return await _newWorkoutStore.update(
      await _database,
      workout.toMap(),
      finder: finder,
    );
  }

//  Future<List<Workout>> updateWorkout(Workout workout) async {
//    print("$TAG : updateWorkSet: workout: ${workout.name}");
//
//    final finder = Finder(filter: Filter.equals("name", workout.name));
//
//    // find a record
//    var _workout =
//    await _newWorkoutStore.findFirst(await _database, finder: finder);
//
//    // record snapshot are read-only.
//    // If you want to modify it you should clone it
//    if (_workout != null) {
//      var map = cloneMap(_workout.value);
//      var newExercise = Workout.fromMap(map);
//      //updating sortId
//      newExercise.sortId
//      //adding new
//      newExercise.workSets.add(newWorkSet.toMap());
//      print(
//          "exercise not null ,updateWorkSet replace by newExercise: ${newExercise.toMap()}");
//      return await _exercisesStore
//          .update(await _database, newExercise.toMap(), finder: finder)
//          .then((_) {
//        return getExercises(workout);
//      });
//    } else {
//      print(
//          "exercise is null ,updateWorkSet data exercise: ${exercise.toMap()}");
//      return await _exercisesStore
//          .add(await _database, exercise.toMap())
//          .then((_) {
//        return getExercises(workout);
//      });
//    }
//  }

  Future<dynamic> deleteWorkout(Workout workout) async {
    final finder = Finder(filter: Filter.byKey(workout.id));
    return await _newWorkoutStore
        .delete(
      await _database,
      finder: finder,
    )
        .then((_) {
      //delete exercises
      _exerdao.getExercises(workout).then((exers) {
        exers.forEach((exercise) {
          _exerdao.deleteExercise(exercise, workout);
        });
      });
    });
  }

  Future<List<Workout>> getWorkoutsFromDao() async {
    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('sortId'),
    ]);

    final recordSnapshots = await _newWorkoutStore.find(
      await _database,
      finder: finder,
    );
//todo fix reorder error .. cant update the view . but probably updating the database
    // Making a List<Workout> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final workout = Workout.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      workout.id = snapshot.key;
      print("workout dao : ${workout.toMap()}");
      print("workout dao : snapshot.key ${snapshot.key}");
      return workout;
    }).toList();
  }

  Future<bool> hasWorkout(String workoutName) async {
    //
    final finder = Finder(
        filter: Filter.and([
      Filter.equals("name", workoutName),
    ]));
    //
    var _workoutList =
        await _newWorkoutStore.find(await _database, finder: finder);
    print("workout data length: ${_workoutList.length}");
    return _workoutList.length > 0;
  }

  Future<List<Workout>> reorder(int oldIndex, int newIndex) {
    return getWorkoutsFromDao().then((oldWorkouts) {
      if (newIndex > oldWorkouts.length) newIndex = oldWorkouts.length;
      if (oldIndex < newIndex) newIndex--;

      var workout = oldWorkouts[oldIndex];
      oldWorkouts.remove(workout);
      oldWorkouts.insert(newIndex, workout);
      int sortId;
      var newWorkouts = List<Workout>();
      oldWorkouts.forEach((w) {
        print("$TAG reorder workouts: ${w.toMap()}");
        sortId = sortId == null ? 0 : ++sortId;
        var workout = Workout(
          w.name,
          w.startTime,
          sortId,
        );
        workout.id = w.id;
        newWorkouts.add(workout);
      });
      return newWorkouts;
    }).then((newWorkouts) {
      newWorkouts.forEach((workout) {
        print("$TAG reorder newWorkouts : ${workout.toMap()}");
      });
      //replace outdated exers
      return updateWorkouts(newWorkouts).then((_) {
        //get updated exers with updated sortId
        return newWorkouts;
//
//        return getWorkoutsFromDao().then((workouts) {
//          workouts.forEach((w) {
//            print("$TAG reorder before push getWorkoutsFromDao : ${w.toMap()}");
//          });
//        });
      });
    });
  }

  Future<dynamic> updateWorkouts(List<Workout> newWorkouts) async {
    //update workout
    var processCount = 0;
    for (final w in newWorkouts) {
      updateWorkout(w).then((_) {
        ++processCount;
        print("$TAG , updateWorkouts :  workout ${w.toMap()}");
        print("$TAG , updateWorkouts :  processCount $processCount");
      });

      if (processCount == newWorkouts.length) {
        print("$TAG , updateWorkouts :  return processCount: $processCount");
        return Future<void>.value();
      }
    }
  }
}
