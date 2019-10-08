import 'package:flutter/material.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/views/workout_item.dart';

class HomeView extends StatelessWidget {

  //injection without context dependency
  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();

  @override
  Widget build(BuildContext context) {
    var _exercises = List<Exercise>();
    _exercises.add(Exercise("Bench Press"));
    _exercises.add(Exercise("Inclined Bench Press"));
    _exercises.add(Exercise("French Press"));
    _exercises.add(Exercise("Overhead Press"));
    _exercises.add(Exercise("Lateral Raises"));
    _exercises.add(Exercise("Front Raises"));

    var _workout = List<Workout>();
    _workout.add(Workout("PUSH DAY", _exercises));
    _workout.add(Workout("PULL DAY", _exercises));
    _workout.add(Workout("CORE DAY", _exercises));

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Strongr"),
          elevation: 0,
        ),
        body: StreamBuilder(
          stream: _workoutBloc.valOutput,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              //initialize.. todo put init inside the bloc
              _workoutBloc.valInput(_exercises);
              return Container();
            } else {
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
            }
          },
        ),
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            size: 40,
          ),
          onPressed: () {
            _workoutBloc.valInput(_exercises);
          },
        ),
      ),
    );
  }
}
