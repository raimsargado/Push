import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/exercise/views/exercise_item.dart';
import 'package:strongr/home/home_view.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/bloc/workout_bloc_api.dart';
import 'package:strongr/workout/models/workout.dart';

class WorkoutView extends StatefulWidget {
  //
  final Workout workout;

  WorkoutView({this.workout});

  @override
  _WorkoutViewState createState() => _WorkoutViewState();
}

class _WorkoutViewState extends State<WorkoutView> {
  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();

  var _textController = TextEditingController();
  FocusNode _textFocus = new FocusNode();
  bool _isChanged = false;
  Timer _debounce;
  String newWorkoutName;

  @override
  void initState() {
    _textController.addListener(onChange);
    _textFocus.addListener(onChange);
    _textController.text = widget.workout.name;
  }


  @override
  void dispose() {
    super.dispose();
    _textController.removeListener(onChange);
    _textFocus.removeListener(onChange);
  }

  void onChange() {
    newWorkoutName = _textController.text;
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      print("onChange");
      if (hasChanges()) {
        setState(() {
          _isChanged = true;
          _textController.value.copyWith(
              text: newWorkoutName,
              selection: TextSelection(
                  baseOffset: newWorkoutName.length,
                  extentOffset: newWorkoutName.length));
          FocusScope.of(context).requestFocus(_textFocus);
        });
      } else {
        setState(() {
          _isChanged = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //get workout name
    //join workout name to list of workset item
    var _exercises = List<Exercise>();
    _exercises.add(Exercise("BENCH PRESS"));
    _exercises.add(Exercise("OH PRESS"));
    _exercises.add(Exercise("LEG PRESS"));

    return _isChanged
        ? WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: GestureDetector(
              onPanUpdate: (details) {
                print("onPanUpdate details direction ${details.delta.dx} ");
                if (details.delta.dx > 0) {
                  displayChangesDialog(context);
                }
              },
              child: _scaffold(_exercises),
            ),
          )
        : _scaffold(_exercises);
  }

  _scaffold(_exercises) {
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          size: 40,
        ),
        onPressed: () {
          _exerciseBloc.valInput(Exercise("CHEST MACHINE PRESS"));
        },
      ),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            print("onpress text controller: ${_textController.text}");
            print("onpress old name: ${widget.workout.name}");
            //detect if has changes
            if (hasChanges()) {
              //show dialog if wanna save or discard changes
              displayChangesDialog(context);
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
                    alignLabelWithHint: true,
                    hintText: widget.workout.name),
                controller: _textController,
              ),
            ),
            Expanded(
              flex: 0,
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _displayDeleteDialog();
                },
              ),
            )
          ],
        ),
      ),
      body: StreamBuilder<Exercise>(
          initialData: Exercise("BOOTY PRESS"),
          stream: _exerciseBloc.valOutput,
          builder: (context, snapshot) {
            _exercises.add(snapshot.data);
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        var _exercise = _exercises?.elementAt(index);
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                          child: ExerciseItem(exercise: _exercise),
                        );
                      }, childCount: _exercises?.length),
                ),
              ],
            );
          }),
    );
  }

  bool hasChanges() {
    return _textController.text.isNotEmpty &&
        widget.workout.name != _textController.text;
  }

  void displayChangesDialog(context) {
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

                  _workoutBloc.valDelete(widget.workout);

                  //TODO toast "changes saved."
                },
              )
            ],
          );
        });
  }
}
