import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class WorkoutTimer extends StatefulWidget {
  final Function() notifyParent;

  const WorkoutTimer({Key key, this.notifyParent}) : super(key: key);

  @override
  _WorkoutTimerState createState() => _WorkoutTimerState();
}

class _WorkoutTimerState extends State<WorkoutTimer> {
  SharedPreferences _prefs;

  DateTime _startedDateTime;

  String TAG = 'WorkoutTimer';
  String START_TIME = 'START_TIME';
  String IS_WORKOUT_STARTED = "IS_WORKOUT_STARTED";

  bool _isWorkoutStarted = false;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    }).then((_) {
//      _initWidgets();
      //todo wip refact
//      _startTimer();
    });
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
                  setState(() {
                    _isWorkoutStarted = false;
                  });
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

  void _startWorkout() {
    //set state icon
    print("$TAG _startWorkout: prefs: $_prefs");
    _prefs.setBool(IS_WORKOUT_STARTED, true).then((b) {
      print("$TAG _startWorkout: setBool _isWorkoutStarted: $b");

      _isWorkoutStarted = true;
      _startTimer();
    });
  }

  Timer _timer;
  int _timeCount = 0;
  String _timeOutput = "";

  void _startTimer() {
    if (_prefs.getBool(IS_WORKOUT_STARTED) != null &&
        _prefs.getBool(IS_WORKOUT_STARTED)) {
      //..
      //just if true
      _isWorkoutStarted = true; //for widget filter

      //if theres no stored start time
      //..store the start time
      var prevStartTime = _prefs.getString(START_TIME);
      if (prevStartTime == null || prevStartTime.isEmpty) {
        print("$TAG start time : isEmpty");
        _startedDateTime = DateTime.now();
        _prefs.setString(START_TIME, _startedDateTime.toString()).then((b) {
          //start timer
          //fresh start of timer
          //..
          _timeCount = 0;
          print("date now : ${new DateTime.now().millisecondsSinceEpoch} ");
          const oneSec = const Duration(seconds: 1);
          _timer = new Timer.periodic(
            oneSec,
            (Timer timer) => setState(() {
              _timeCount = ++_timeCount;
            }),
          );
        });
      } else {
        //has started time stored
        //..
        //compute the current time count before continuing the timer
        //..get the diff of start time vs the current date time
        _startedDateTime = DateTime.parse(_prefs.getString(START_TIME));
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
          (Timer timer) => setState(() {
            _timeCount = ++_timeCount;
          }),
        );
        //..continue the timer count

        print("$TAG , TIMER : usedtime: $usedTime");
        print("$TAG , TIMER : _timeCount: $_timeCount");
      }
    }
  }

  Future<void> _stopWorkout() async {
    widget.notifyParent();
    _prefs.clear();
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
