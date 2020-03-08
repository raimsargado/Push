import 'dart:async';

import 'package:flutter/material.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:push/workout/models/workout.dart';

class WorkoutTimer extends StatefulWidget {
  final Function() saveCallback;
  final Workout workout;

  const WorkoutTimer({Key key, this.saveCallback, this.workout})
      : super(key: key);

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer>
    with WidgetsBindingObserver {
  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();

  DateTime _startedDateTime;

  String TAG = 'WorkoutTimer';

  bool _isWorkoutStarted = false;

  @override
  void initState() {
    if (widget.workout.startTime != null &&
        widget.workout.startTime.isNotEmpty) {
      _startedDateTime = DateTime.parse(widget.workout.startTime);
    }
    _startTimer();
    print("$TAG , init state _startedDateTime : $_startedDateTime");

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("$TAG AppLifecycleState resumed");
        _startTimer();
        break;
      case AppLifecycleState.inactive:
        print("$TAG AppLifecycleState inactive");
        break;
      case AppLifecycleState.paused:
        print("$TAG AppLifecycleState paused");
        break;
      case AppLifecycleState.detached:
        print("$TAG AppLifecycleState detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _isWorkoutStarted
            ? Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
                child: Center(
                    child: Text("${format(Duration(seconds: _timeCount))}")),
              )
            : Container(),
        _isWorkoutStarted
            ? IconButton(
                icon: Icon(Icons.pause_circle_outline),
                onPressed: () {
                  //stop workout
                  _displayStopWorkoutDialog();
                },
              )
            : IconButton(
                icon: Icon(Icons.play_circle_outline),
                onPressed: () {
                  //start workout
                  print("$TAG start time: _startWorkout:");
                  //todo wip refact
//                  widget.notifyParent();
                  setState(() {
                    _isWorkoutStarted = true;
                  });
                  _startWorkout();
//                      initPlatformState();
                },
              ),
      ],
    );
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  //this can only be triggered via play button for only once
  void _startWorkout() {
    print("$TAG _startWorkout: _startedDateTime : $_startedDateTime");
    //
    _startedDateTime = DateTime.now();
    //update the workout
    var w = Workout(
      widget.workout.name,
      _startedDateTime.toString(),
      widget.workout.sortId,
    );
    w.id = widget.workout.id;
    _workoutBloc.valUpdate(w);
    //start timer
    _startTimer();
  }

  Timer _timer;
  int _timeCount = 0;
  String _timeOutput = "";

  void _startTimer() {
    if (_timer != null) {
      //reset
      _timer.cancel();
    }
    if (_startedDateTime != null) {
      //..
      //just if true
      _isWorkoutStarted = true; //for widget filter

      //has started time stored
      //..
      //compute the current time count before continuing the timer
      //..get the diff of start time vs the current date time
      print("$TAG start time : not empty: $_startedDateTime");
      var dateNow = DateTime.now();
      //..convert the diff to seconds

      var usedTime = dateNow.difference(_startedDateTime).inSeconds;

      //..convert into timer count
      _timeCount = usedTime;
      print("date now : ${new DateTime.now().millisecondsSinceEpoch} ");
      const oneSec = const Duration(seconds: 1);
      _timer = new Timer.periodic(
        oneSec,
        (Timer timer) {
          if (mounted) {
            setState(() {
              _timeCount = ++_timeCount;
            });
          }
        },
      );
      //..continue the timer count
      print("$TAG , TIMER : usedtime: $usedTime");
      print("$TAG , TIMER : _timeCount: $_timeCount");
    }
  }

  Future<void> _stopWorkout() async {
    //clear started time
    var w = Workout(
      widget.workout.name,
      null,
      widget.workout.sortId,
    );
    w.id = widget.workout.id;
    _workoutBloc.valUpdate(w);
    //save
    widget.saveCallback();
    //reset vars
    setState(() {
      _isWorkoutStarted = false;
      _timer.cancel();
      _timeCount = 0;
    });
  }

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
                  //todo wip refact
                  _stopWorkout();
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          );
        });
  }
}
