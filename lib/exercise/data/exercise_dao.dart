import 'package:sembast/sembast.dart';
import 'package:strongr/app_db_interface.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';

class ExerciseDao {
  StoreRef _exercisesStore;

  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;

  Future addExercise(Exercise exercise) async {
    await _exercisesStore.add(await _database, exercise.toMap());
  }

  void deleteExercise(Exercise exercise) {
    // TODO: implement deleteExercise
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

 Future<bool> hasWorkout(Exercise exercise) async {
   final finder =
   Finder(filter: Filter.greaterThanOrEquals("name", exercise.name));
   var _exercises =
       await _exercisesStore.find(await _database, finder: finder);
   print("exercise data length: ${_exercises.length}");
   return _exercises.length > 0;
 }
}
