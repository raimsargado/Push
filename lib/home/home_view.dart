import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  var _lastClickedWorkout;

  @override
  Widget build(BuildContext context) {

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
          print("homeview snapshot data: ${snapshot.data}");
          if (snapshot.data == null) {
            //initialize.. todo put init inside the bloc
//              _workoutBloc.valInput(_exercises);s
            return Center(
              child: CircularProgressIndicator());
          } else {
            var workouts = snapshot.data as List<Workout>;
            print("home_view workouts: ${workouts.length}");
            if (workouts.isNotEmpty) {
              var wList = workouts.toSet().toList();
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      var _workout = wList?.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                        child: WorkoutItem(workout: _workout),
                      );
                    }, childCount: wList?.length),
                  ),
                ],
              );
            } else {
              return Center(
                child: Text("If I were you, "
                    "\nI will start adding workout now."),
              );
            }
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
                  _workoutBloc
                      .valSearch(Workout(_textFieldController.text))
                      .then((isExist) {
                    print("workout exist: $isExist");
                    if (!isExist) {
                      _workoutBloc
                          .valCreate(Workout(_textFieldController.text));
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Sorry dude, this workout exists!",
                        gravity: ToastGravity.CENTER,
                      );
                    }
                    //TODO TOAAST EXIST OR NOT EXIST
                    //TODO ADD MEMBER METHOD TO CRUD EXERCISES WITHIN THE WORKOUT BLOC
                  });
                },
              )
            ],
          );
        });
  }
}
