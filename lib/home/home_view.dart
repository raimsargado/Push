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

  @override
  Widget build(BuildContext context) {
//    final String assetName = 'assets/BikiniDoodle.svg';
//    final Widget svg = SvgPicture.asset(
//      assetName,
//      semanticsLabel: 'Empty',
//
//    );

    print("build stateless $_workouts");
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
            return Center(child: CircularProgressIndicator());
          } else {
            var workouts = snapshot.data as List<Workout>;
            workouts.forEach((w) {
              print("home_view workout: ${w.toMap()}");
            });
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/BikiniDoodle.png')),
                    Text("Add workout now and achieve your bikini body."),
                  ],
                ),
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
        },
      ),
    );
  }

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    _textFieldController.text = "";
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
                      .valSearch(_textFieldController.text)
                      .then((isExist) {
                    print("workout exist: $isExist");
                    if (!isExist) {
                      _workoutBloc.valCreate(
                          Workout(_textFieldController.text, "", null));
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Sorry dude, this workout exists!",
                        gravity: ToastGravity.CENTER,
                      );
                    }
                  });
                },
              )
            ],
          );
        });
  }
}
