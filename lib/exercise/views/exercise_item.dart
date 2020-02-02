import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';
import 'package:strongr/workset/views/workset_item.dart';

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

  @override
  void initState() {
    _initWidgets();
  }

  @override
  void didUpdateWidget(ExerciseItem oldWidget) {
    print("did update widget widget.exercise : ${widget.exercise.toMap()}");
    _initWidgets();
    setState(() {
      _wSets?.forEach((w) {
        print("$TAG setState updated wsets : ${w.toMap()}");
      });
    });
  }
//todo DONE TAG IS REMOVING AFTER LONG PRESS
  //todo minimize item on press .. before reordering
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        print("$TAG onTapDown");
//        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //ITEM HEADER
              Row(
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
                      _exerciseBloc.deleteExercise(_exercise, widget.workout);
                    },
                  )
                ],
              ),
              //ITEM SUBHEADER
              Row(
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
              //WORKSET LIST
              CustomScrollView(
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
              //ADD BUTTON
              FlatButton(
                child: Text("Add Set"),
                onPressed: () {
                  _exerciseBloc.addWorkSet(_exercise, widget.workout);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _initWidgets() {
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
}
