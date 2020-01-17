import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:strongr/custom_widgets/overlay_progressbar.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/exercise/views/exercise_item.dart';
import 'package:strongr/home/home_view.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkoutView extends StatefulWidget {
  //
  final Workout workout;

  WorkoutView({this.workout});

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  //
  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();
  var _exerciseNameFieldController = TextEditingController();

  var _workoutNameController = TextEditingController();
  FocusNode _textFocus = new FocusNode();
  Timer _debounce;
  String newWorkoutName;
  var progressBar = CustomProgressBar();

  bool _isWorkoutStarted = false;

  @override
  // ignore: must_call_super
  void initState() {
    _workoutNameController.addListener(_onChange);
    _textFocus.addListener(_onChange);
    _workoutNameController.text = widget.workout.name;
    _exerciseBloc.initExercises(widget.workout);
  }

  @override
  void dispose() {
    super.dispose();
    _workoutNameController.removeListener(_onChange);
    _textFocus.removeListener(_onChange);
  }

  void _onChange() {
    newWorkoutName = _workoutNameController.text;
    print("_onChange orig workout name ${widget.workout.name}");
    print("_onChange newWorkoutName  $newWorkoutName");

    if (_hasChanges()) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        var w = Workout(_workoutNameController.text);
        w.id = widget.workout.id;
        //update workout db
        _workoutBloc.valUpdate(w);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    return _scaffold();
  }

  _scaffold() {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          size: 40,
        ),
        onPressed: () {
          _displayAddExerciseDialog(context);
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            print("onpress text controller: ${_workoutNameController.text}");
            print("onpress old name: ${widget.workout.name}");
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) => HomeView(),
              ),
            );
          },
        ),
        centerTitle: false,
        title: Row(
          children: <Widget>[
            //WORKOUT TITLE
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    alignLabelWithHint: true, hintText: widget.workout.name),
                controller: _workoutNameController,
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              _displayDeleteDialog();
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
            child: _isWorkoutStarted
                ? IconButton(
                    icon: Icon(Icons.pause_circle_outline),
                    onPressed: () {
                      //stop workout
                      stopWorkout();
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.play_circle_outline),
                    onPressed: () {
                      //start workout
                      _startWorkout();
                    },
                  ),
          ),
          _isWorkoutStarted
              ? Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                  child: Center(
                      child: Text("${format(Duration(seconds: _timeCount))}")),
                )
              : Container()
        ],
      ),
      body: StreamBuilder<List<Exercise>>(
          stream: _exerciseBloc.valOutput,
          builder: (context, snapshot) {
            print("exercises: ${snapshot.data}");

            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image(image: AssetImage('assets/MoshingDoodle.png')),
                      Text("Slight warm-up will do before starting."),
                    ],
                  ),
                );
              } else {
                var exercises = snapshot.data;
                return CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        var _exercise = exercises?.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                          child: ExerciseItem(
                              workout: widget.workout, exercise: _exercise),
                        );
                      }, childCount: exercises?.length),
                    ),
                  ],
                );
              }
            }
          }),
    );
  }

  bool _hasChanges() {
    return _workoutNameController.text.isNotEmpty &&
        widget.workout.name != _workoutNameController.text;
  }

  void _displayDeleteDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure to delete workout?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('NOPE'),
                onPressed: () {
                  //go back to previous page
                  Navigator.pop(context);
                  //toast "changes not saved"
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView(),
                    ),
                  );

                  _workoutBloc.valDelete(widget.workout);
                },
              )
            ],
          );
        });
  }

  _displayAddExerciseDialog(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          _exerciseNameFieldController.text = "";
          return new AlertDialog(
            title: Text('Add exercise'),
            content: new TextField(
              controller: _exerciseNameFieldController,
              decoration: InputDecoration(hintText: "eg. Chest Press"),
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
                  _exerciseBloc
                      .valSearch(_exerciseNameFieldController.text)
                      .then((isExist) {
                    print("exercise exist: $isExist");
                    if (!isExist) {
                      _exerciseBloc.valCreate(
                        Exercise(
                          name: _exerciseNameFieldController.text,
                          workSets: [WorkSet(set: "1").toMap()],
                          //empty placeholder as initial workSet
                          weightUnit: "Kg",
                        ),
                      );
                      Navigator.of(context, rootNavigator: true).pop();
                    } else {
                      Fluttertoast.showToast(
                        msg: "Sorry dude, this exercise exists!",
                        gravity: ToastGravity.CENTER,
                      );
                    }
                    //TODO TOAAST EXIST OR NOT EXIST
                  });
                },
              )
            ],
          );
        });
  }

  void _startWorkout() {
    //set state icon
    _isWorkoutStarted = true;
    setState(() {});
    startTimer();
  }

  Timer _timer;
  int _timeCount = 0;
  String _timeOutput = "";

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(() {
        _timeCount = ++_timeCount;
      }),
    );
  }

  void stopWorkout() {
    //set state icon
    _displayStopWorkoutDialog();
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  void _displayStopWorkoutDialog() {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return new AlertDialog(
            title: Container(child: Text('😒😒😒😒😒😒')),
            content: Text(
              'Are you sure to \nstop your workout?',
              textAlign: TextAlign.center,
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
                  //stop workout
                  _isWorkoutStarted = false;
                  setState(() {});
                  _timer.cancel();
                  _timeCount = 0;
                  Navigator.of(context, rootNavigator: true).pop();
                  //save all progress
                  //update each exercise
                  //update each workSet on each exercise
                  _exerciseBloc.saveAllProgress();
                },
              )
            ],
          );
        });
  }
}
