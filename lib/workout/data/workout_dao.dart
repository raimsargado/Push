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
    await _newWorkoutStore.update(
      await _database,
      workout.toMap(),
      finder: finder,
    );
  }

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
      SortOrder('name'),
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

  Future<bool> hasWorkout(Workout workout) async {
    //
    final finder = Finder(
        filter: Filter.and([
      Filter.equals("name", workout.name),
    ]));
    //
    var _workoutList =
        await _newWorkoutStore.find(await _database, finder: finder);
    print("workout data length: ${_workoutList.length}");
    return _workoutList.length > 0;
  }
}
