import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:push/custom_widgets/pascal_case_text_formatter.dart';
import 'package:push/custom_widgets/upper_case_text_formatter.dart';
import 'package:push/reusables/dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:push/custom_widgets/overlay_progressbar.dart';
import 'package:push/exercise/bloc/exercise_bloc_api.dart';
import 'package:push/exercise/models/exercise.dart';
import 'package:push/exercise/views/exercise_item.dart';
import 'package:push/exercise/views/exercise_reorder_view.dart';
import 'package:push/home/home_view.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workout/views/workout_timer.dart';
import 'package:push/workset/models/workset.dart';

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

  String _startTime;

  bool _isFromSorting = false;

  _saveAllProgress() {
    print("$TAG, refresh _saveAllProgress workout: ${widget.workout.toMap()}");
    print("$TAG, refresh _saveAllProgress exers: ${widget.workout.toMap()}");
    //save all progress
    //update each exercise
    //update each workSet on each exercise
    _exerciseBloc.saveAllProgress(widget.workout);
  }

  @override
  void initState() {
    super.initState();
    _initWidgets();

    print("$TAG init state");
  }

  @override
  void dispose() {
    super.dispose();
    _workoutNameController.removeListener(_onChange);
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        print("$TAG AppLifecycleState resumed");
//        _startTimer();
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
  void didUpdateWidget(WorkoutView oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    _initWidgets();
  }

  void _onChange() {
    newWorkoutName = _workoutNameController.text;
    print("_onChange orig workout name ${widget.workout.name}");
    print("_onChange newWorkoutName  $newWorkoutName");

    if (_hasChanges()) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        var w = Workout(
          _workoutNameController.text,
          _startTime,
          widget.workout.sortId,
        );
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            //TITLE AREA
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      print("onpress text :${_workoutNameController.text}");
                      print("onpress old name: ${widget.workout.name}");
                      Navigator.pop(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()),
                      );
                    },
                  ),
                  Expanded(
                    child: TextField(
                      textAlign: TextAlign.center,
                      inputFormatters: [UpperCaseTextFormatter()],
                      decoration: InputDecoration(
                          alignLabelWithHint: true,
                          hintText: widget.workout.name),
                      controller: _workoutNameController,
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 18,
                      ),
                    ),
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
                            sortCallback: _isSorted,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            //OPTIONS
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //WORKOUT TITLE
                  Container(
                    margin: EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: WorkoutTimer(
                        saveCallback: _saveAllProgress,
                        //will trigger the [_saveAllProgress()]
                        workout: widget.workout),
                  ),
                  GestureDetector(
                    child: Container(
                      child: Text(
                        "DELETE",
                        style: TextStyle(fontSize: 18),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 0, 8, 0),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          shape: BoxShape.rectangle,
                          color: Colors.grey),
                    ),
                    onTap: () async {
                      var decision = await Dialogs.decisionDialog(
                        context,
                        "Delete Workout",
                        'Are you sure to delete workout?',
                        "Yes",
                        "No",
                      );
                      if (decision == DialogAction.positive) {
                        Navigator.pop(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeView(),
                          ),
                        );
                        _workoutBloc.valDelete(widget.workout);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: StreamBuilder<List<Exercise>>(
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
                              Text(
                                "Slight warm-up will do before starting.",
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            ],
                          ),
                        );
                      } else {
                        _exercises = snapshot.data;
                        _exercises.forEach((exer) {
                          print(
                              "$TAG NOT EMPTY reorderexer _exerciseBloc.valOutput exercises: ${exer.toMap()}");
                        });
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
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 4, 2, 0),
                                  child: ExerciseItem(
                                      workout: widget.workout,
                                      exercise: _exercise),
                                );
                              }, childCount: _exercises?.length),
                            ),
                          ],
                        );
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: GestureDetector(
          onTap: () => _displayAddExerciseDialog(context),
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

  bool _hasChanges() {
    return _workoutNameController.text.isNotEmpty &&
        widget.workout.name != _workoutNameController.text;
  }

  _displayAddExerciseDialog(BuildContext context) async {
    _isAddingExercise = true;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          _exerciseNameFieldController.text = "";
          return new AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Add exercise'),
            content: new TextField(
              inputFormatters: [PascalCaseTextFormatter()],
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

  _isSorted() {
    print("$TAG sort callback triggered");
    _isFromSorting = true;
  }
}
