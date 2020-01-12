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

  var _textController = TextEditingController();
  FocusNode _textFocus = new FocusNode();
  Timer _debounce;
  String newWorkoutName;
  var progressBar = CustomProgressBar();

  @override
  // ignore: must_call_super
  void initState() {
    _textController.addListener(_onChange);
    _textFocus.addListener(_onChange);
    _textController.text = widget.workout.name;
    _exerciseBloc.initExercises(widget.workout.name);
  }

  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(_onChange);
    _textFocus.removeListener(_onChange);
  }

  void _onChange() {
    newWorkoutName = _textController.text;
    print("orig workout name ${widget.workout.name}");

    print("onChange haschanges ${_hasChanges()}");
    if (_hasChanges()) {
      if (_debounce?.isActive ?? false) _debounce.cancel();
      _debounce = Timer(const Duration(milliseconds: 1000), () {
        setState(() {
          _exerciseBloc.initExercises(widget.workout.name);
          _textController.value.copyWith(
              text: newWorkoutName,
              selection: TextSelection(
                  baseOffset: newWorkoutName.length,
                  extentOffset: newWorkoutName.length));
          FocusScope.of(context).requestFocus(_textFocus);
        });
      });
    } else {
      setState(() {
        _exerciseBloc.initExercises(widget.workout.name);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //

    return _hasChanges()
        ? WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: GestureDetector(
              onPanUpdate: (details) {
                print("onPanUpdate details direction ${details.delta.dx} ");
                if (details.delta.dx > 0) {
                  _displayChangesDialog(context);
                }
              },
              child: _scaffold(),
            ),
          )
        : _scaffold();
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
            print("onpress text controller: ${_textController.text}");
            print("onpress old name: ${widget.workout.name}");
            //detect if has changes
            if (_hasChanges()) {
              //show dialog if wanna save or discard changes
              _displayChangesDialog(context);
            } else {
              //go back to previous page
              Navigator.pop(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeView(),
                ),
              );
            }
          },
        ),
        centerTitle: false,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    alignLabelWithHint: true, hintText: widget.workout.name),
                controller: _textController,
              ),
            ),
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: () {
                  _displayDeleteDialog();
                },
              ),
            )
          ],
        ),
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
                  child: Text("Dude , tap that damn add button then"
                      " \nstart adding exercises."),
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
    return _textController.text.isNotEmpty &&
        widget.workout.name != _textController.text;
  }

  void _displayChangesDialog(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Save changes?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('DISCARD'),
                onPressed: () {
                  //go back to previous page
                  Navigator.pop(context);
                  Navigator.pop(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeView(),
                    ),
                  );
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

                  var w = Workout(_textController.text);
                  w.id = widget.workout.id;
                  //update workout db
                  _workoutBloc.valUpdate(w);

                  //toast "changes saved."
                },
              )
            ],
          );
        });
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

                  //TODO toast "changes saved."
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
                          workSets: [WorkSet(set: "1").toMap()], //empty placeholder as initial workSet
                          weightUnit: "Kgs",
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
}
