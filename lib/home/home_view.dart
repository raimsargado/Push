import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      appBar: AppBar(
        title: Text("Push"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
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
        ],
      ),
      body: StreamBuilder(
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
    _workoutBloc.clearWorkouts().then((_){
      setState(() {
        print("tag refresh");
      });
    }).then((_){
      _workoutBloc.init();
    });

  }
}
