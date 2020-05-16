import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          GestureDetector(
            onTap: ()=>Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BackupView(
                  refreshCallback: () => _refreshApp(),
                ),
              ),
            ),
              child: Container(
                  width: 42,
                  child: Center(child: custom()))),
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

  Widget custom() {
    // Adobe XD layer: 'Icon ionic-md-optio…' (group)
    return // Adobe XD layer: 'Icon ionic-md-optio…' (group)
      // Adobe XD layer: 'Icon ionic-md-optio…' (group)
      SvgPicture.string(
        '<svg viewBox="2.3 2.3 16.3 16.3" ><g transform="translate(2.25, 12.75)"><path transform="translate(-2.25, -24.67)" d="M 2.25 27 L 12.16850757598877 27 L 12.16850757598877 28.16688346862793 L 2.25 28.16688346862793 L 2.25 27 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-14.71, -24.67)" d="M 28.125 27 L 31.04220962524414 27 L 31.04220962524414 28.16688346862793 L 28.125 28.16688346862793 L 28.125 27 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-12.0, -22.5)" d="M 24.83376693725586 27.14929962158203 C 24.83376693725586 27.80381393432617 24.31133270263672 28.33441543579102 23.66688346862793 28.33441543579102 L 23.66688346862793 28.33441543579102 C 23.02243423461914 28.33441543579102 22.5 27.80381393432617 22.5 27.14929962158203 L 22.5 23.68511581420898 C 22.5 23.03060531616211 23.02243423461914 22.5 23.66688346862793 22.5 L 23.66688346862793 22.5 C 24.31133270263672 22.5 24.83376693725586 23.03060531616211 24.83376693725586 23.68511581420898 L 24.83376693725586 27.14929962158203 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></g><g transform="translate(2.25, 7.5)"><path transform="translate(-2.25, -14.54)" d="M 2.25 16.875 L 5.167207717895508 16.875 L 5.167207717895508 18.04188346862793 L 2.25 18.04188346862793 L 2.25 16.875 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-8.21, -14.54)" d="M 14.625 16.875 L 24.54350662231445 16.875 L 24.54350662231445 18.04188346862793 L 14.625 18.04188346862793 L 14.625 16.875 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-5.5, -12.37)" d="M 11.33376693725586 17.02429962158203 C 11.33376693725586 17.67881202697754 10.81133079528809 18.20941543579102 10.16688346862793 18.20941543579102 L 10.16688346862793 18.20941543579102 C 9.522436141967773 18.20941543579102 9 17.67881202697754 9 17.02429962158203 L 9 13.56011581420898 C 9 12.90560340881348 9.522436141967773 12.375 10.16688346862793 12.375 L 10.16688346862793 12.375 C 10.81133079528809 12.375 11.33376693725586 12.90560340881348 11.33376693725586 13.56011581420898 L 11.33376693725586 17.02429962158203 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></g><g transform="translate(2.25, 2.25)"><path transform="translate(-2.25, -4.42)" d="M 2.25 6.75 L 12.16850757598877 6.75 L 12.16850757598877 7.91688346862793 L 2.25 7.91688346862793 L 2.25 6.75 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-14.71, -4.42)" d="M 28.125 6.75 L 31.04220962524414 6.75 L 31.04220962524414 7.91688346862793 L 28.125 7.91688346862793 L 28.125 6.75 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /><path transform="translate(-12.0, -2.25)" d="M 24.83376693725586 6.899300575256348 C 24.83376693725586 7.553812980651855 24.31133270263672 8.084416389465332 23.66688346862793 8.084416389465332 L 23.66688346862793 8.084416389465332 C 23.02243423461914 8.084416389465332 22.5 7.553812980651855 22.5 6.899300575256348 L 22.5 3.435115814208984 C 22.5 2.780603647232056 23.02243423461914 2.25 23.66688346862793 2.25 L 23.66688346862793 2.25 C 24.31133270263672 2.25 24.83376693725586 2.780603647232056 24.83376693725586 3.435115814208984 L 24.83376693725586 6.899300575256348 Z" fill="#f7f7f7" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></g></svg>',
        allowDrawingOutsideViewBox: true,
      );
  }
}
