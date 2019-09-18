import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/bloc/workout_bloc.dart';
import 'package:strongr/models/workout.dart';
import 'package:strongr/views/workout_item.dart';

class RootView extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    var _workoutProvider = Provider.of<WorkoutBloc>(context);

    var _workout = List<Workout>();
    _workout.add(Workout("PUSH DAY"));
    _workout.add(Workout("PULL DAY"));
    _workout.add(Workout("CORE DAY"));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            size: 40,
          ),
          onPressed: () {
            _workoutProvider.valController.sink.add(Workout("Leg Day"));
          },
        ),
        appBar: AppBar(
          title: Text("Strongr"),
          elevation: 0,
        ),
        body: StreamBuilder<Workout>(
          initialData: Workout("initial"),
          stream: _workoutProvider.valOutput,
          builder: (context, snapshot) {
            _workout.add(snapshot.data);
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    var _exercise = _workout?.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                      child: WorkoutItem(workout: _exercise),
                    );
                  }, childCount: _workout?.length),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
