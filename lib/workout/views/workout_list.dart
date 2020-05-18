// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:push/backup_restore/backup_view.dart';
import 'package:push/custom_widgets/upper_case_text_formatter.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workout/views/workout_item.dart';

class WorkoutListView extends StatefulWidget {
  final Function() themeCallback;

  const WorkoutListView({Key key, this.themeCallback}) : super(key: key);

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
      body: Column(
        children: <Widget>[
          SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
              child: Row(
                children: <Widget>[
                  IconButton(
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
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        "PUSH",
                        style: TextStyle(
                          fontFamily: 'Helvetica Neue',
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: IconButton(
                    icon: Icon(Icons.brightness_medium),
                    iconSize: 28,
                    onPressed: () {
                      widget.themeCallback();
                    },
                  )),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.fromLTRB(24, 32, 0, 0),
            child: Text(
              "Your Workouts",
              style: TextStyle(
                fontFamily: 'Helvetica Neue',
                fontSize: 24,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
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
                              padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
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
                            Text(
                              "Add a workout now!",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () => _displayDialog(context),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.black87),
            margin: EdgeInsets.fromLTRB(0, 0, 10, 30),
            child: Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
          ),
        ),
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
