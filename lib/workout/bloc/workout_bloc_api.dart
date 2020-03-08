
import 'package:push/app_bloc.dart';

abstract class WorkoutBlocApi with AppBloc{
  void reorder(int oldIndex, int newIndex);
}