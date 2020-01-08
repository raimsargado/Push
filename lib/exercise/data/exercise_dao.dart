import 'package:sembast/sembast.dart';
import 'package:sembast/utils/value_utils.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workset/models/workset.dart';

class ExerciseDao {
  StoreRef _exercisesStore;

  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;

  Future addExercise(Exercise exercise) async {
    await _exercisesStore.add(await _database, exercise.toMap());
  }

  Future<dynamic> deleteExercise(Exercise exercise) async {
    final finder = Finder(filter: Filter.byKey(exercise.id));
    return await _exercisesStore.delete(
      await _database,
      finder: finder,
    );
  }

  // TODO: implement exercise
  Exercise get exercise => null;

  // TODO: implement exercises
  Future<List<Exercise>> getExercises(String workoutName) async {
    //INIT THE STORE , [workoutName] as store ref
    _exercisesStore = intMapStoreFactory.store(workoutName);

    // Finder object can also sort data.
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _exercisesStore.find(
      await _database,
      finder: finder,
    );

    // Making a List<Workout> out of List<RecordSnapshot>
    return recordSnapshots.map((snapshot) {
      final exercise = Exercise.fromMap(snapshot.value);
      // An ID is a key of a record from the database.
      exercise.id = snapshot.key;
      return exercise;
    }).toList();
  }

  void updateExercise(Exercise exercise) {
    // TODO: implement updateExercise
  }

  Future<bool> hasExercise(Exercise exercise) async {
    final finder = Finder(filter: Filter.equals("name", exercise.name));
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

  //TODO FIX ID IS ALWAYS NULL AT FIRST ADD SET
  Future<Exercise> addWorkSet(Exercise exercise) async {
    print("exercise input addWorkSet: id: ${exercise.name}");

    final finder = Finder(filter: Filter.equals("name", exercise.name));

    // find a record
    var _exercise =
        await _exercisesStore.findFirst(await _database, finder: finder);

// record snapshot are read-only.
// If you want to modify it you should clone it
    if (_exercise != null) {
      var map = cloneMap(_exercise.value);
      var newExercise = Exercise.fromMap(map);
      newExercise.workSets.add(WorkSet().toMap());
      print("exercise not null , replace by newExercise: ${newExercise.toMap()}");
      return await _exercisesStore
          .update(await _database, newExercise.toMap(), finder: finder)
          .then((_) {
        return Future<Exercise>.value(newExercise);
      });
    } else {
      print("exercise is null , data exercise: ${exercise.toMap()}");
      return await _exercisesStore
          .add(await _database, exercise.toMap())
          .then((_) {
        return Future<Exercise>.value(exercise);
      });
    }
  }
}

//TODO PUT STREAMBUILDER FOR WORKSETS
