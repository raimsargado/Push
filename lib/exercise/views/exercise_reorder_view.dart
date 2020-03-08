import 'package:flutter/material.dart';
import 'package:push/exercise/bloc/exercise_bloc_api.dart';
import 'package:push/exercise/models/exercise.dart';
import 'package:push/exercise/views/exercise_reorder_item.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workout/views/workout_view.dart';

class ExerciseReorderView extends StatefulWidget {
  final Function() sortCallback;
  final List<Exercise> exercises;
  final Workout workout;

  const ExerciseReorderView({Key key, this.exercises, this.workout, this.sortCallback})
      : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<ExerciseReorderView> {
  var TAG = "ExerciseReorderView";

  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  List<Exercise> _exercises;

  @override
  void initState() {
    //setup exercises
    _exerciseBloc.initExercises(widget.workout);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutView(),
              ),
            );
          },
        ),
        centerTitle: false,
        title: Text("Sort your exercises"),
      ),
      body: StreamBuilder<List<Exercise>>(
          stream: _exerciseBloc.valOutputWithoutRefresh,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              print(
                  "$TAG _exerciseBloc.valOutput exercises NULL loading..: ${snapshot.data}");
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('assets/MoshingDoodle.png')),
                      Text("Slight warm-up will do before starting."),
                    ],
                  ),
                );
              } else {
                _exercises = snapshot.data;
                return ReorderableListView(
                    children: [
                      for (final exer in _exercises)
                        Padding(
                          key: ValueKey(exer.id),
                          padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                          child: ExerciseReorderItem(exercise: exer),
                        ),
                    ],
                    onReorder: (oldIndex, newIndex) {

                      print("$TAG onReorder oldIndex: $oldIndex");
                      print("$TAG onReorder newIndex $newIndex");
                      widget.sortCallback();
                      _exerciseBloc.reorder(oldIndex, newIndex, widget.workout);
                    });
              }
            }
          }),
    );
  }
}
