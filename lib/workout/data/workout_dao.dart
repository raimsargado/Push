import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
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

  final _workoutStore = StoreRef<String, dynamic>.main();
  final _exerciseStore = StoreRef<String, dynamic>.main();
  final _worksetStore = StoreRef<String, dynamic>.main();

  //finding and updating a workout

  Future<Workout> insert(Workout workout) async {
    //TODO 1:: ADD WORKOUT FIRST AND GET THE KEY

    //this is where the new workout is added AT THE ROOT OF THE TABLE
    //
    // then retrieving the [workoutRecord] , its actually a key

    var workoutRecord = await _workoutStore.add(await _database, {
      "workout_name": workout.name,
//      "exercises": [
//        "exercise1 KEY",
//        "exercise2 KEY",
//        "exercise3 KEY",
//      ],
    });

    //TODO 2:: UPDATE THE WORKOUT LIST

    //then adding the key to workouts table
    updateWorkouts(workoutRecord);

    return workout;
  }

  Future<void> updateWorkouts(String workoutKey) async {
    //
    if (_database != null) {
      //getting all workout keys via [finder] then [records]
      final finder = Finder(filter: Filter.byKey("workout_list"));
      var records =
          await _workoutStore.findFirst(await _database, finder: finder);

      if (records != null) {
        //clone the data
        var data = cloneMap(records.value);
        //modify
        var workouts = data["workouts"] as List;
        workouts.add(workoutKey);
        data["workouts"] = workouts;

        print("data workouts: $workouts");

        //update list via batch
        return await _workoutStore
            .record("workout_list")
            .update(await _database, data);
      } else {
        //first save
        return await _workoutStore.record("workout_list").add(
          await _database,
          {
            "workouts": [workoutKey],
          },
        );
      }
    }
  }

  Future<Workout> addWorkout(Workout workout) async {
    return await insert(workout);
  }

  void deleteWorkout(Workout workOut) {
    // TODO: implement deleteWorkout
  }

  void updateWorkout(Workout workout) {
//      data.add(workout.name);
//      await _workoutStore.update(
//        await _database,
//        {
//          "username": "John john dex",
//          "hasAuth": false,
//          "picUrl": "picUrl",
//          "bio": "Unmodified",
//        },
//        finder: finder,
//      );

//      if (records.isEmpty) {
//        var key = await _workoutStore.record('test').put(main.db, {
//          "username": "John Doex",
//          "hasAuth": false,
//          "picUrl": "picUrl",
//          "bio": "Bulking brah",
//        });
//      } else {
//
//      }
  }

  // TODO: implement workout
  Future<Workout> getWorkout(String workoutKey) async {
    // Finder object can also sort data.
    final finder = Finder(
      filter: Filter.byKey(workoutKey),
    );

    return await _workoutStore
        .findFirst(await _database, finder: finder)
        .then((snapshot) {
      Map<String, dynamic> workoutData = cloneMap(snapshot.value);
      String workoutName = workoutData["workout_name"];
      return Workout(workoutName);
    });
  }

  // TODO: implement workouts
  Future<List<dynamic>> get workouts async {
//    // getting all the saved workout keys
//    final finder = Finder(
//      filter: Filter.byKey("workout_list"),
//    );
//
//    final workouts = List<Workout>();
//
//    final recordSnaps = await _worksetStore.find(
//      await _database,
//      finder: finder,
//    );
//
    // getting all the saved workout keys
    final recordSnapshots =
        await _workoutStore.record("workout_list").get(await _database);

    //converting to list
    List<dynamic> data = cloneMap(recordSnapshots)["workouts"];

    return data;
//    return data.map((workoutKey) {
//     return getWorkout(workoutKey).then((workout) {
//        print("wokout_dao workoutKey: $workoutKey  to workout: ${workout.name}");
//        return workout;
//      });
//    }).toList();

//
//    List<Workout> _workouts;
//    return await data.forEach((key) async {
//      getWorkout(key).then((workout) {
//        _workouts.add(workout);
//      }).then((workouts) {
//        return _workouts;
//      });
//    });

//    recordSnaps.map((value) {
//      print("recordSnapshots ${value}");
//      List<dynamic> data = cloneMap(value.value)["workouts"];
//      print("data ${data}");
//
//    });
//    var workouts = cloneMap(recordSnapshots.);
//    var workouts = List<Workout>();
    // Making a List<Workout> out of List<RecordSnapshot>
//   return recordSnapshots.map((snapshot) {
//      //find single workout by key

//    });
//
//    return recordSnapshots.map((snapshot) {
////      final fruit = Fruit.fromMap(snapshot.value);
////      // An ID is a key of a record from the database.
////      fruit.id = snapshot.key;
//
//      print("workouts ${snapshot}");
//      Map<String, dynamic> workoutValue = cloneMap(snapshot.value);
//
//      print("workoutValue ${workoutValue}");
//      List<dynamic> workoutKeys = workoutValue["workouts"];
//
//      workoutKeys.forEach((key) {
//        print("key ${key}");
//        getWorkout(key).then((workout) {
//          return workout;
//        });
//      });
//    }).toList();
  }
}
