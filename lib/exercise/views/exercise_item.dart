import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push/exercise/bloc/exercise_bloc_api.dart';
import 'package:push/exercise/models/exercise.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/models/workout.dart';
import 'package:push/workset/models/workset.dart';
import 'package:push/workset/views/workset_item.dart';

class ExerciseItem extends StatefulWidget {
  final Exercise exercise;
  final Workout workout;

  const ExerciseItem({Key key, this.workout, this.exercise}) : super(key: key);

  @override
  _ExerciseItemState createState() => _ExerciseItemState();
}

class _ExerciseItemState extends State<ExerciseItem> {
  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();
  var _wSets = List<WorkSet>();
  var newWorkSets = List<WorkSet>();
  String _defaultWeightUnit;
  var TAG = "EXER ITEM";
  Exercise _exercise;

  _initWidgets() {
    print(
        "$TAG , _initWidgets exer : ${widget.exercise.toMap()}");
    _exercise = widget.exercise;
    _wSets.clear();
    _exercise.workSets.forEach((workSetMap) {
      _wSets.add(WorkSet.fromMap(workSetMap));
    });
    _wSets.sort(
      (a, b) => a.set.toString().compareTo(b.set.toString()),
    );
    _defaultWeightUnit = _exercise.weightUnit;
  }

  @override
  void initState() {
    _initWidgets();
  }

  @override
  void didUpdateWidget(ExerciseItem oldWidget) {
    print(
        "$TAG , did update widget widget.exercise : ${widget.exercise.toMap()}");
    _initWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            //ITEM HEADER
            Flexible(
              fit: FlexFit.loose,
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                      child: Text(
                        _exercise.name,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      //displaydialog
                      _displayDeleteExerDialog(
                          context, _exercise, widget.workout);
                    },
                  )
                ],
              ),
            ),

            //CONTENTS FROM SUBHEADER TO ADD SET BUTTON
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //ITEM SUBHEADER
                  Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("SET")),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("RECENT")),
                        ),
                        //WEIGHT HEADER
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
                            child: Card(
                              child: MaterialButton(
                                child: Text(
                                  _defaultWeightUnit,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                onPressed: () {
                                  switch (_defaultWeightUnit) {
                                    case "Kg":
                                      _defaultWeightUnit = "Lb";
                                      break;
                                    case "Lb":
                                      _defaultWeightUnit = "Lvl";
                                      break;
                                    case "Lvl":
                                      _defaultWeightUnit = "Kg";
                                      break;
                                  }
                                  setState(() {});
                                  var exer = _exercise.toMap();
                                  print("$TAG onpress weight exer: $exer");
                                  exer['weightUnit'] = _defaultWeightUnit;
                                  _exerciseBloc.updateExercise(
                                      Exercise.fromMap(exer), widget.workout);
                                },
                              ),
                            ),
                          ),
                        ),
                        //PADDING
                        Expanded(flex: 0, child: Center(child: Text(" "))),
                        //REPS HEADER
                        Expanded(
                          flex: 1,
                          child: Center(child: Text("REPS")),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                  //WORKSET LIST
                  Flexible(
                    fit: FlexFit.loose,
                    child: CustomScrollView(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      slivers: <Widget>[
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                            var _workSet = _wSets?.elementAt(index);
                            return Dismissible(
                              direction: DismissDirection.endToStart,
                              key: Key(_workSet.set + "${Random(10000)}"),
                              onDismissed: (direction) {
                                _exerciseBloc.deleteWorkSet(
                                    _exercise, _workSet, widget.workout);
                                // Shows the information on Snackbar
                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text("Item removed.")));
                              },
                              child: WorkSetItem(
                                workSet: _workSet,
                                exercise: _exercise,
                                workout: widget.workout,
                              ),
                            );
                          }, childCount: _wSets?.length),
                        ),
                      ],
                    ),
                  ),
                  //ADD BUTTON
                  Flexible(
                    fit: FlexFit.loose,
                    child: FlatButton(
                      child: Text("Add Set"),
                      onPressed: () {
                        _exerciseBloc.addWorkSet(_exercise, widget.workout);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _displayDeleteExerDialog(
    BuildContext context,
    Exercise exercise,
    Workout workout,
  ) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return new AlertDialog(
            title: Text('Delete exercise: '),
            content: Wrap(
              children: [
                Center(child: Text('${exercise.name.toUpperCase()}')),
              ],
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
                  _exerciseBloc.deleteExercise(exercise, workout);
                  Navigator.of(context, rootNavigator: true).pop();
                },
              )
            ],
          );
        });
  }
}
