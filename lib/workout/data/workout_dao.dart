import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
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
    await _newWorkoutStore.update(
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

//  Future<List<Workout>> reorderWorkouts(
//      int oldIndex, int newIndex, Workout workout) {
//    print(
//        "$TAG reorder oldIndex: $oldIndex , newIndex: $newIndex workout: ${workout.toMap()}");
//    return getWorkoutsFromDao().then((oldExercises) {
//      if (newIndex > oldExercises.length) newIndex = oldExercises.length;
//      if (oldIndex < newIndex) newIndex--;
//
//      var exercise = oldExercises[oldIndex];
//      oldExercises.remove(exercise);
//      oldExercises.insert(newIndex, exercise);
//      var sortId;
//      var newExercises = List<Exercise>();
//      oldExercises.forEach((exer) {
//        print("$TAG reorderexer exercises: ${exer.toMap()}");
//        sortId = sortId == null ? 0 : ++sortId;
//        newExercises.add(
//          Exercise(
//              sortId: sortId,
//              name: exer.name,
//              workSets: exer.workSets,
//              weightUnit: exer.weightUnit),
//        );
//      });
//
//      return newExercises;
//    }).then((newExers) {
//      newExers.forEach((exer) {
//        print("$TAG reorderexer newExercises : ${exer.toMap()}");
//      });
//
//      //replace outdated exers
//      return replaceExercises(newExers, workout).then((_) {
//        //get updated exers with updated sortId
//        return getExercises(workout).then((exers) {
//          exers.forEach((e) {
//            print("$TAG reorderexer before push getExercises : ${e.toMap()}");
//          });
//          return exers;
//        });
//      });
//    });
//  }

}
