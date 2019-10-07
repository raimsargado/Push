import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/data/exercise_repo_api.dart';
import 'package:strongr/service_init.dart';

class ExerciseBloc extends ExerciseBlocApi {

  var _exerciseRepo = serviceLocator.get<ExerciseRepoApi>();

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
