
import 'package:strongr/app_bloc.dart';
import 'package:strongr/workout/models/workout.dart';

abstract class WorkoutBlocApi with AppBloc{
  void valUpdate(Workout workout) {}
}