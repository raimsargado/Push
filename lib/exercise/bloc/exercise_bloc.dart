import 'package:strongr/exercise/bloc/exercise_bloc_interface.dart';
import 'package:strongr/exercise/data/exercise_repo_interface.dart';
import 'package:strongr/main.dart';

class ExerciseBloc extends ExerciseBlocInterface {

  var _exerciseRepo = serviceLocator.get<ExerciseRepoInterface>();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  void valInput(any) {
    // TODO: implement valInput
  }

  @override
  // TODO: implement valOutput
  Stream get valOutput => null;
}
