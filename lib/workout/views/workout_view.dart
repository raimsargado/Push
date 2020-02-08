import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:strongr/custom_widgets/overlay_progressbar.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/exercise/views/exercise_item.dart';
import 'package:strongr/exercise/views/exercise_reorder_view.dart';
import 'package:strongr/home/home_view.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/views/workout_timer.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkoutView extends StatefulWidget {
  //
  final Workout workout;

  WorkoutView({this.workout});

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> with WidgetsBindingObserver {
  //
  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();

  var _exerciseNameFieldController = TextEditingController();

  var _scrollController = new ScrollController();

  var _workoutNameController = TextEditingController();
  Timer _debounce;
  String newWorkoutName;
  var progressBar = CustomProgressBar();

  bool _isWorkoutStarted = false;
  bool _isAddingExercise = false;

  var TAG = "WORKOUTVIEW";

//  var _textFocus = FocusNode();

  var _currentExer;

  List<Exercise> _exercises;

  SharedPreferences _prefs;

  DateTime _startedDateTime;

  String START_TIME = 'START_TIME';

  String IS_WORKOUT_STARTED = "IS_WORKOUT_STARTED";

  refresh() {
    print("$TAG, refresh");
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    }).then((_) {
      _initWidgets();
      //todo wip refact
//      _startTimer();
    });

    print("$TAG init state");
  }

  @override
  void dispose() {
    super.dispose();
    _workoutNameController.removeListener(_onChange);
    WidgetsBinding.instance.removeObserver(this);
  }

  AppLifecycleState _notification;

  @override
  void didUpdateWidget(WorkoutView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _initWidgets();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("$TAG AppLifecycleState resumed");
        //todo wip refact
//        _startTimer();
        break;
      case AppLifecycleState.inactive:
        print("$TAG AppLifecycleState inactive");
        //todo
        //store start time if inactive..
        _prefs.setString(START_TIME, _startedDateTime.toString()).then((b) {
          _prefs.setBool(IS_WORKOUT_STARTED, _isWorkoutStarted).then((b) {
            //todo wip refact
//            _timer.cancel();
//            _timeCount = 0;
          });
        });

        //if time stops or time terminated
        //..store the date time now of start time

        break;
      case AppLifecycleState.paused:
        print("$TAG AppLifecycleState paused");

        break;
      case AppLifecycleState.detached:
        print("$TAG AppLifecycleState detached");

        break;
    }
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
    //focus clear before updating
    //so workset item wont update itself on onChange listener
    if (!_isWorkoutStarted && !_isAddingExercise)
      FocusScope.of(context).requestFocus(new FocusNode());

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
//                focusNode: _textFocus,
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
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseReorderView(
                    exercises: _exercises,
                    workout: widget.workout,
                  ),
                ),
              );
            },
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: WorkoutTimer(
                notifyParent: refresh, //will trigger the [refresh()]
              )

//            _isWorkoutStarted
//                ? IconButton(
//                    icon: Icon(Icons.pause_circle_outline),
//                    onPressed: () {
//                      //stop workout
//                      _displayStopWorkoutDialog();
//                    },
//                  )
//                : IconButton(
//                    icon: Icon(Icons.play_circle_outline),
//                    onPressed: () {
//                      //start workout
//                      print(
//                          "$TAG start time: _startWorkout:");
//                      //todo wip refact
////                      _startWorkout();
////                      initPlatformState();
//                    },
//                  ),
              ),
//          _isWorkoutStarted
//              ? Padding(
//                  padding: const EdgeInsets.fromLTRB(0, 0, 14, 0),
//                  child: Center(
//                    child: WorkoutTimer(notifyParent: refresh),
//                  ))
//              : Container()
        ],
      ),
      body: StreamBuilder<List<Exercise>>(
          stream: _exerciseBloc.valOutput,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              print(
                  "$TAG _exerciseBloc.valOutput exercises NULL loading..: ${snapshot.data}");
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
                _exercises = snapshot.data;
                _exercises.forEach((exer) {
                  print(
                      "$TAG NOT EMPTY reorderexer _exerciseBloc.valOutput exercises: ${exer.toMap()}");
                });
//                _exercises.sort((a, b) {
//                  print("$TAG TOSORT : A: ${a.toMap()} , B: ${b.toMap()}");
//                  return a.id.compareTo(b.id);
//                });
                print("$TAG ADDING EXER: $_isAddingExercise");
                return CustomScrollView(
                  controller: _scrollController,
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        var _exercise = _exercises?.elementAt(index);
                        print("$TAG _exercise: ${_exercise.toMap()}");
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                          child: ExerciseItem(
                              workout: widget.workout, exercise: _exercise),
                        );
                      }, childCount: _exercises?.length),
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
    _isAddingExercise = true;
    showDialog(
        context: context,
        barrierDismissible: false,
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
                  _isAddingExercise = false;
                },
              ),
              FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  _exerciseBloc
                      .searchExercise(_exerciseNameFieldController.text)
                      .then((isExist) {
                    print("exercise exist: $isExist");
                    if (!isExist) {
                      _exerciseBloc.createExercise(
                          Exercise(
                            name: _exerciseNameFieldController.text,
                            workSets: [WorkSet(set: "1").toMap()],
                            //empty placeholder as initial workSet
                            weightUnit: "Kg",
                          ),
                          widget.workout);
                      Navigator.of(context, rootNavigator: true).pop();
                      _isAddingExercise = true;
                      Timer(Duration(milliseconds: 1000), () {
                        _scrollController
                            .animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 100),
                          curve: Curves.ease,
                        )
                            .then((_) {
                          print("scroll to end");
                          _isAddingExercise = false;
                          setState(() {});
                        });
                      });
                    } else {
                      Fluttertoast.showToast(
                        msg: "Sorry dude, this exercise exists!",
                        gravity: ToastGravity.CENTER,
                      );
                      _isAddingExercise = false;
                    }
                  });
                },
              )
            ],
          );
        });
  }


  void _initWidgets() {
    _workoutNameController.addListener(_onChange);
    _workoutNameController.text = widget.workout.name;
    _exerciseBloc.initExercises(widget.workout);
  }
}
