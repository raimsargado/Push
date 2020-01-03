import 'package:sembast/sembast.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutDao {
  //
  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;

  //workout_store
  //exercise_store
  //workSet_store

  var workout_data = [
    {
      "workout_name": "Push day",
      "exercises": [
        {
          "exer_name": "Bench press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
        {
          "exer_name": "OHP press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
        {
          "exer_name": "DECLINE press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
      ],
    },
    {
      "workout_name": "PULL day",
      "exercises": [
        {
          "exer_name": "Bench press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
        {
          "exer_name": "OHP press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
        {
          "exer_name": "DECLINE press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
      ],
    },
    {
      "workout_name": "LEGS day",
      "exercises": [
        {
          "exer_name": "Bench press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
        {
          "exer_name": "OHP press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
        {
          "exer_name": "DECLINE press",
          "previous": "10kgX8reps",
          "weight": "20kg",
          "reps": "10 reps",
          "status": "done"
        },
      ],
    },
  ];

  static const String WORKOUT_STORE_NAME = 'WORKOUTS';
  final _newWorkoutStore = intMapStoreFactory.store(WORKOUT_STORE_NAME);

  Future addWorkout(Workout workout) async {
    await _newWorkoutStore.add(await _database, workout.toMap());
  }

  Future update(Workout workout) async {
    // For filtering by key (ID), RegEx, greater than, and many other criteria,
    // we use a Finder.
    final finder = Finder(filter: Filter.byKey(workout.id));
    await _newWorkoutStore.update(
      await _database,
      workout.toMap(),
      finder: finder,
    );
  }

  Future<dynamic> deleteWorkout(Workout workOut) async {
    final finder = Finder(filter: Filter.byKey(workOut.id));
    return await _newWorkoutStore.delete(
      await _database,
      finder: finder,
    );
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
