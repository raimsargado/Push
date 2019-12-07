import 'package:flutter/material.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/views/workout_item.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: WorkoutListView(), /**[WorkoutListView] as home page**/
    );
  }
}

// ignore: must_be_immutable
class WorkoutListView extends StatelessWidget {

  //injection without context dependency
  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();
  var _workouts = List<Workout>();

  @override
  Widget build(BuildContext context) {
//
//    var _exercises = List<Exercise>();
//    _exercises.add(Exercise("Bench Press"));
//    _exercises.add(Exercise("Inclined Bench Press"));
//    _exercises.add(Exercise("French Press"));
//    _exercises.add(Exercise("Overhead Press"));
//    _exercises.add(Exercise("Lateral Raises"));
//    _exercises.add(Exercise("Front Raises"));
//

    print("build stateless $_workouts");
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Strongr"),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _workoutBloc.valOutput,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            //initialize.. todo put init inside the bloc
//              _workoutBloc.valInput(_exercises);s
            return Center(
              child: Text("If I were you, "
                  "\nI will start adding workout now."),
            );
          } else {
            _workouts.add(snapshot.data as Workout);
            var workouts = _workouts.toSet().toList();
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    var _workout = workouts?.elementAt(index);
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                      child: WorkoutItem(workout: _workout),
                    );
                  }, childCount: workouts?.length),
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
          _displayDialog(context);
//            _workoutBloc.valInput(Workout("My First Workout"));
        },
      ),
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Add a workout'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "eg. Pull Day"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  _workoutBloc.valInput(Workout(_textFieldController.text));
                },
              )
            ],
          );
        });
  }

}
