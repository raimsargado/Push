import 'package:flutter/material.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/exercise/views/exercise_item.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/bloc/workset_bloc_api.dart';
import 'package:strongr/workset/models/workset.dart';
import 'package:strongr/workset/views/workset_item.dart';

class WorkoutView extends StatelessWidget {
  //
  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  final Workout workout;

  WorkoutView({this.workout});

  @override
  Widget build(BuildContext context) {
    //get workout name
    //join workout name to list of workset item
    var _exercises = List<Exercise>();
    _exercises.add(Exercise("BENCH PRESS"));
    _exercises.add(Exercise("OH PRESS"));
    _exercises.add(Exercise("LEG PRESS"));

    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          size: 40,
        ),
        onPressed: () {
          _exerciseBloc
              .valInput(Exercise("CHEST MACHINE PRESS"));
        },
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    alignLabelWithHint: true, hintText: workout.name),
              ),
            ),
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(Icons.directions_run),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder<Exercise>(
          initialData: Exercise("BOOTY PRESS"),
          stream: _exerciseBloc.valOutput,
          builder: (context, snapshot) {
            _exercises.add(snapshot.data);
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    var _exercise = _exercises?.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                      child: ExerciseItem(exercise: _exercise),
                    );
                  }, childCount: _exercises?.length),
                ),
              ],
            );
          }),
    );
  }
}
