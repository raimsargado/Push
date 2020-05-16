import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:push/backup_restore/backup_view.dart';
import 'package:push/custom_widgets/upper_case_text_formatter.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workout/views/workout_item.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
class WorkoutListView extends StatefulWidget {
  //injection without context dependency
  @override
  _WorkoutListViewState createState() => _WorkoutListViewState();
}

class _WorkoutListViewState extends State<WorkoutListView> {
  //
  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();

  var _workouts = List<Workout>();

  var TAG = "WorkoutListView";

  @override
  Widget build(BuildContext context) {
    //
    print("build stateless $_workouts");
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: SafeArea(
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "PUSH",
                          style: TextStyle(
                            fontFamily: 'Helvetica Neue',
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                          width: 60,
                          child: Center(
                              child: IconButton(
                            icon: Icon(Icons.menu),
                            iconSize: 28,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BackupView(
                                    refreshCallback: () => _refreshApp(),
                                  ),
                                ),
                              );
                            },
                          ))),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(24, 0, 0, 0),
                    child: Text(
                      "Your Programs",
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 24,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 24, 0, 70),
                  child: StreamBuilder(
                    stream: _workoutBloc.valOutput,
                    builder: (context, snapshot) {
                      print("homeview snapshot data: ${snapshot.data}");
                      print(
                          "homeview snapshot connectionState: ${snapshot.connectionState}");
                      if (snapshot.data == null &&
                          snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        var workouts = snapshot.data as List<Workout>;
                        if (workouts != null && workouts.isNotEmpty) {
                          workouts.forEach((w) {
                            print("home_view workout: ${w.toMap()}");
                          });
                          var wList = workouts.toSet().toList();

                          return ReorderableListView(
                            children: <Widget>[
                              for (final workout in wList)
                                Padding(
                                  key: ValueKey(workout.id),
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 4, 2, 0),
                                  child: WorkoutItem(workout: workout),
                                ),
                            ],
                            onReorder: (oldIndex, newIndex) {
                              print("$TAG onReorder oldIndex: $oldIndex");
                              print("$TAG onReorder newIndex $newIndex");

                              _workoutBloc.reorder(oldIndex, newIndex);
                            },
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Add workout now!"),
                              ],
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500].withOpacity(0.5),
                      offset: Offset(0, 3), // changes position of shadow
                      spreadRadius: 3,
                      blurRadius: 3,
                    ),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(16))),
              child: Row(
                children: <Widget>[],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: IconButton(
                icon: IconShadowWidget(
                  Icon(
                    Icons.add_circle,
                    size: 65,
                  ),
                  shadowColor: Colors.black87,
                ),
                iconSize: 65,
                color: Colors.black87,
                onPressed: () {
                  _displayDialog(context);
                },
              ),
            ),
          )
        ],
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Add a workout'),
            content: TextField(
              inputFormatters: [UpperCaseTextFormatter()],
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

  _refreshApp() {
    //
    _workoutBloc.clearWorkouts().then((_) {
      setState(() {
        print("tag refresh");
      });
    }).then((_) {
      _workoutBloc.init();
    });
  }
}
