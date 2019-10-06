import 'package:sembast/sembast.dart';
import 'package:strongr/db/app_db_interface.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/main.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutDao {
  //
  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseInterface>().database;

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

  final _workoutStore = StoreRef<String, dynamic>.main();
  final _exerciseStore = StoreRef<String, dynamic>.main();
  final _worksetStore = StoreRef<String, dynamic>.main();

  //finding and updating a workout

  Future insert(Workout workout) async {
    print("appdb : $_database");
    var key = "push day";
    var value = [Exercise("bench press")];

    //todo note : .put returns record/s
    //todo note : .add returns key

    //TODO DATA list SHOULD ALWAYS BE A MAP SO WE CAN EDIT VIA "cloneMap"
    //TODO WE CAN DIRECTLY EDIT A MAP VALUE VIA FINDER BY KEY UPDATER
    //1. add workout to workout list.. via workout_store .. record key 'workout_list'
    var records = await _workoutStore.record("workout_list").put(
      await _database,
      {
        "workouts": [
          "key1",
          "key2",
          "key3",
        ],
      },
    );

//2. add single workout item(has the list of exercise
// .. all are just keys) to workout store ..
// key AUTO (SO WE CAN FIND VIA KEY)
    //todo adding workout
    var workoutRecord = await _workoutStore.add(await _database, {
      "workout_name": "Push Day",
      "exercises": [
        "exercise1 KEY",
        "exercise2 KEY",
        "exercise3 KEY",
      ],
    });

//3. add single exercise item
// (has the list of worksets)
// .. all are just keys) to exercise store..
// key AUTO (so we can find via key)
    var exerciseRecord = await _exerciseStore.add(await _database, {
      "exercise_name": "bench press",
      "sets": [
        "WORKSET1 KEY",
        "WORKSET2 KEY",
        "WORKSET3 KEY",
      ],
    });

//4  add single workset item which has the workset details .
// .. to WORKSET STORE. AUTO KEY (SO WE CAN FIND VIA KEY)
    var worksetRecord = await _worksetStore.add(await _database, {
      "set_name": "1st",
      "exer_name": "Bench press",
      "previous": "10kgX8reps",
      "weight": "20kg",
      "reps": "10 reps",
      "status": "done"
    });
  }

  Future updateWorkout(Workout workout) async {
    print(_database);
    if (_database != null) {
      final finder = Finder(filter: Filter.equals('test', 'test'));
      var records = await _workoutStore.find(await _database, finder: finder);
      await _workoutStore.update(
        await _database,
        {
          "username": "John john dex",
          "hasAuth": false,
          "picUrl": "picUrl",
          "bio": "Unmodified",
        },
        finder: finder,
      );
//      if (records.isEmpty) {
//        var key = await _workoutStore.record('test').put(db, {
//          "username": "John Doex",
//          "hasAuth": false,
//          "picUrl": "picUrl",
//          "bio": "Bulking brah",
//        });
//      } else {
//
//      }
    }
  }

  void addWorkout(Workout workout) {
    // TODO: implement addWorkout
  }

  void deleteWorkout(Workout workOut) {
    // TODO: implement deleteWorkout
  }

  // TODO: implement workout
  Workout get workout => null;

  // TODO: implement workouts
  List<Workout> get workouts => null;
}
