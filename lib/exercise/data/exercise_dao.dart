import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';
//TODO ALTERNATIVE IN BACKGROUND TIMER

class ExerciseDao {
  StoreRef _exercisesStore;

  var TAG = "EXERDAO";

  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;

  Future<dynamic> addExercise(Exercise exercise, Workout workout) async {
    return await _exercisesStore
        .add(await _database, exercise.toMap())
        .then((_) {
      return getExercises(workout);
    });
  }

  Future<dynamic> deleteExercise(Exercise exercise, Workout workout) async {
    final finder = Finder(filter: Filter.equals("name", exercise.name));
    return await _exercisesStore
        .delete(
      await _database,
      finder: finder,
    )
        .then((_) {
      return getExercises(workout);
    });
  }

  Exercise get exercise => null;

  Future<List<Exercise>> getExercises(Workout workout) async {
    //INIT THE STORE , [workoutName] as store ref
    print("$TAG get exers workout ${workout.toMap()}");
    _exercisesStore = intMapStoreFactory.store(workout.id.toString());

    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _exercisesStore.find(
      await _database,
      finder: finder,
    );

    // Making a List<Exercise> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final exercise = Exercise.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      exercise.id = snapshot.key;
      return exercise;
    }).toList();
  }

  Future<dynamic> updateExercise(Exercise exercise, Workout workout) async {
    print("exercise input updateExercise: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    return await _exercisesStore
        .update(await _database, exercise.toMap(), finder: finder)
        .then((_) async {
      return await getExercises(workout);
    });
  }

  Future<bool> hasExercise(String exerciseName) async {
    final finder = Finder(filter: Filter.equals("name", exerciseName));
    var _exercises =
        await _exercisesStore.find(await _database, finder: finder);

    print("exercise data length: ${_exercises}");
    return _exercises.length > 0;
  }

  Future<Exercise> getExercise(Exercise exercise) async {
    final finder = Finder(filter: Filter.byKey(exercise.id));
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

    print("exercise data length: ${_exercise}");
    return _exercise.value;
  }

  Future<List<Exercise>> addWorkSet(Exercise exercise, Workout workout) async {
    print("exercise input addWorkSet: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    // find a record
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

// record snapshot are read-only.
// If you want to modify it you should clone it
    if (_exercise != null) {
      print("$TAG exercise not null ${_exercise}");

      var map = cloneMap(_exercise.value);
      var newExercise = Exercise.fromMap(map);
      print(
          "$TAG newExercise not null cloneMap workSets ${newExercise.workSets}");
      int newSetId;
      String weightHint;
      String repsHint;
      String recent;
      bool tag;
      if (newExercise.workSets.isNotEmpty) {
        int newId = 0;
        var newWSets = List<Map>();
        var orderedSets = List<Map>();
        newExercise.workSets.forEach((w) {
          orderedSets.add(w);
          orderedSets.sort(
            (a, b) => WorkSet.fromMap(a).set.toString().compareTo(
                  WorkSet.fromMap(b).set.toString()),
          );
        });
        orderedSets.forEach((w) {
          var wSet = WorkSet.fromMap(w);
          newWSets.add(WorkSet(
                  set: "${++newId}",
                  recent: wSet.recent ?? "",
                  weight: wSet.weight ?? "",
                  reps: wSet.reps ?? "",
                  tag: wSet.tag ?? false)
              .toMap());
        });

        newExercise.workSets.clear();
        newExercise.workSets.addAll(newWSets);

        var lasWorkSet = WorkSet.fromMap(newExercise.workSets.last);
        newSetId = int.tryParse(newExercise.workSets.last["set"]);
        ++newSetId;
        recent = lasWorkSet.recent ?? "";
        weightHint = lasWorkSet.weight ?? "";
        repsHint = lasWorkSet.reps ?? "";
        var newWorkSet = WorkSet(
          set: newSetId.toString(),
          recent: recent,
          weight: weightHint,
          reps: repsHint,
          tag: false,
        ).toMap();
        //
        newExercise.workSets.add(newWorkSet);
        //
//        updateWorkSetWithoutFuture(newExercise, WorkSet.fromMap(newWorkSet));
        //
      } else {
        //
        newSetId = 1;
        newExercise.workSets.add(
          WorkSet(
            set: newSetId.toString(),
            weight: weightHint,
            reps: repsHint,
          ).toMap(),
        );
      }

      print(
          "exercise not null , replace by newExercise: ${newExercise.toMap()}");
      return await _exercisesStore
          .update(await _database, newExercise.toMap(), finder: finder)
          .then((_) {
        return getExercises(workout);
      });
    } else {
      print("exercise is null , data exercise: ${exercise.toMap()}");
      return await _exercisesStore
          .add(await _database, exercise.toMap())
          .then((_) {
        return getExercises(workout);
      });
    }
  }

  Future<void> updateWorkSetWithoutFuture(
      Exercise exercise, WorkSet newWorkSet) async {
    print("exercise input updateWorkSet: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    // find a record
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

    // record snapshot are read-only.
    // If you want to modify it you should clone it
    if (_exercise != null) {
      var map = cloneMap(_exercise.value);
      var newExercise = Exercise.fromMap(map);
      //removing old
      newExercise.workSets.removeWhere(
        ((workSet) => workSet["set"] == newWorkSet.set),
      );
      //adding new
      newExercise.workSets.add(newWorkSet.toMap());
      print(
          "exercise not null ,updateWorkSet replace by newExercise: ${newExercise.toMap()}");
      await _exercisesStore.update(await _database, newExercise.toMap(),
          finder: finder);
    } else {
      print(
          "exercise is null ,updateWorkSet data exercise: ${exercise.toMap()}");
      await _exercisesStore.add(await _database, exercise.toMap());
    }
  }

  Future<List<Exercise>> updateWorkSet(
      Exercise exercise, WorkSet newWorkSet, Workout workout) async {
    print("exercise input updateWorkSet: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    // find a record
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

    // record snapshot are read-only.
    // If you want to modify it you should clone it
    if (_exercise != null) {
      var map = cloneMap(_exercise.value);
      var newExercise = Exercise.fromMap(map);
      //removing old
      newExercise.workSets.removeWhere(
        ((workSet) => workSet["set"] == newWorkSet.set),
      );
      //adding new
      newExercise.workSets.add(newWorkSet.toMap());
      print(
          "exercise not null ,updateWorkSet replace by newExercise: ${newExercise.toMap()}");
      return await _exercisesStore
          .update(await _database, newExercise.toMap(), finder: finder)
          .then((_) {
        return getExercises(workout);
      });
    } else {
      print(
          "exercise is null ,updateWorkSet data exercise: ${exercise.toMap()}");
      return await _exercisesStore
          .add(await _database, exercise.toMap())
          .then((_) {
        return getExercises(workout);
      });
    }
  }

  Future<Exercise> saveExerciseProgress(Exercise exercise) async {
    //save all progress
    //update each exercise
    //update each workSet on each exercise
    print("exercise input saveExerciseProgress: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    // find a record
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

    // record snapshot are read-only.
    // If you want to modify it you should clone it
    if (_exercise != null) {
      var map = cloneMap(_exercise.value);
      var newExercise = Exercise.fromMap(map);

      var newWorkSets = List<WorkSet>();
      newExercise.workSets.forEach((workSet) {
        var oldWorkSet = WorkSet.fromMap(workSet);

        if ((oldWorkSet.weight != null && oldWorkSet.reps != null) &&
            (oldWorkSet.weight.isNotEmpty && oldWorkSet.reps.isNotEmpty)) {
          var newWorkSet = WorkSet(
              set: oldWorkSet.set,
              recent: oldWorkSet.weight + "X" + oldWorkSet.reps);
          newWorkSet.id = oldWorkSet.id;
          newWorkSets.add(newWorkSet);
        } else {
          var newWorkSet = WorkSet(
            set: oldWorkSet.set,
            recent: oldWorkSet.recent, //retain the old recent
          );
          newWorkSet.id = oldWorkSet.id;
          newWorkSets.add(newWorkSet);
        }
      });

      newWorkSets.forEach((newWorkSet) {
        //removing old
        newExercise.workSets.removeWhere(
          ((workSet) => workSet['set'] == newWorkSet.set),
        );
        //adding new
        newExercise.workSets.add(newWorkSet.toMap());
      });

      //plotting the id from old exercise
      newExercise.id = exercise.id;

      print(
          "exercise not null ,saveExerciseProgress replace by newExercise: ${newExercise.toMap()}");
      return await _exercisesStore
          .update(await _database, newExercise.toMap(), finder: finder)
          .then((_) {
        return Future<Exercise>.value(newExercise);
      });
    } else {
      print(
          "exercise is null ,saveExerciseProgress data exercise: ${exercise.toMap()}");
      return await _exercisesStore
          .add(await _database, exercise.toMap())
          .then((_) {
        return Future<Exercise>.value(exercise);
      });
    }
  }

  Future<dynamic> saveAllProgress(Workout workout) async {
    return await getExercises(workout).then((exercises) async {
      var newExercises = List<Exercise>();
      for (final exercise in exercises) {
        //put debounce
        newExercises.add(await saveExerciseProgress(exercise));
        print("$TAG saveAllProgress newexercises: ${newExercises.length}");
        if (newExercises.length == exercises.length) {
          //remove workout
          return Future<dynamic>.value(newExercises);
        }
      }
    });
  }

  Future<List<Exercise>> deleteWorkSet(
      Exercise exercise, WorkSet workSetToRemove, Workout workout) async {
    print("exercise input delete workset:: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    // find a record
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

    // record snapshot are read-only.
    // If you want to modify it you should clone it
    if (_exercise != null) {
      var map = cloneMap(_exercise.value);
      var newExercise = Exercise.fromMap(map);
      //removing workSet
      newExercise.workSets.removeWhere(
        ((workSet) => workSet["set"] == workSetToRemove.set),
      );

      print("$TAG delete workset: updated worksets: ${newExercise.workSets}");

      print(
          "exercise not null ,delete workset: replace by newExercise: ${newExercise.toMap()}");
      return await _exercisesStore
          .update(await _database, newExercise.toMap(), finder: finder)
          .then((_) {
        return getExercises(workout);
      });
    } else {
      print(
          "exercise is null ,delete workset: data exercise: ${exercise.toMap()}");
      return await _exercisesStore
          .add(await _database, exercise.toMap())
          .then((_) {
        return getExercises(workout);
      });
    }
  }
}
