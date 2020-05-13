import 'package:push/custom_widgets/pascal_case_text_formatter.dart';
import 'package:sembast/sembast.dart';
import 'package:push/app_db_interface.dart';
import 'package:push/exercise/data/exercise_dao.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/models/workout.dart';

class WorkoutDao {
  var dbFunctions = serviceLocator.get<AppDatabaseApi>();

  //
  Future<Database> get _database async {
    return await serviceLocator.get<AppDatabaseApi>().database;
  }

  var _exerdao = ExerciseDao();

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

  Future<dynamic> deleteWorkout(Workout workout) async {
    final finder = Finder(filter: Filter.byKey(workout.id));
    return await _newWorkoutStore
        .delete(await _database, finder: finder)
        .then((_) {
      //delete exercises
      _exerdao.getExercises(workout).then((exers) {
        exers.forEach((exercise) {
          _exerdao.deleteExercise(exercise, workout);
        });
      });
    }).then((_) {
      //update sortIds
      return getWorkoutsFromDao().then((oldWorkouts) {
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
          print(
              "$TAG deleteWorkout method reorder newWorkouts : ${workout.toMap()}");
        });
        //replace outdated exers
        return updateWorkouts(newWorkouts).then((_) {
          //get updated exers with updated sortId
          return newWorkouts;
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
