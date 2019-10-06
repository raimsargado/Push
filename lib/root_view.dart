import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/main.dart';
import 'package:strongr/workout/bloc/workout_bloc.dart';
import 'package:strongr/workout/bloc/workout_bloc_interface.dart';
import 'package:strongr/workout/data/workout_repo.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/views/workout_item.dart';

class RootView extends StatelessWidget {

  var _workoutBloc = serviceLocator.get<WorkoutBlocInterface>();

  @override
  Widget build(BuildContext context) {
    // This widget is the root of your application.

    //todo put this inside a bloc

    var workoutInstance = WorkoutRepo();

    var _workoutProvider = Provider.of<WorkoutBloc>(context);

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
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            size: 40,
          ),
          onPressed: () {
            _workoutBloc.valInput(_exercises);
          },
        ),
        appBar: AppBar(
          title: Text("Strongr"),
          elevation: 0,
        ),
        body: StreamBuilder(
          initialData: Workout("", null),
          stream: _workoutBloc.valOutput,
          builder: (context, snapshot) {
            _workout.add(snapshot.data);
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
      ),
    );
  }
}
