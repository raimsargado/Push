import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/bloc/workset_bloc_api.dart';
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
  var _workSetBloc = serviceLocator.get<WorkSetBlocApi>();
  var _weightFieldController = TextEditingController();
  Exercise _currentExercise; //placeholder of currentexercise
  var _wSets = List<WorkSet>();
  String _defaultWeightUnit;

  var TAG = "EXER ITEM";

  @override
  void initState() {
    print("$TAG exercise: ${widget.exercise.toMap()}");
    widget.exercise.workSets.forEach((workSetMap) {
      _wSets.add(WorkSet.fromMap(workSetMap));
    });
    _wSets.sort(
      (a, b) => a.set.toString().compareTo(b.set.toString()),
    );
    _defaultWeightUnit = widget.exercise.weightUnit;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
//        Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context) => WorkoutView(workout: workout),
//          ),
//        );
      },
      child: Card(
//        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                        widget.exercise.name,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline),
                    onPressed: () {
                      _exerciseBloc.valDelete(widget.exercise);
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
                  Expanded(
                    flex: 1,
                    child: Card(
                      child: MaterialButton(
                        child: Text(
                          _defaultWeightUnit,
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () {
                          switch (_defaultWeightUnit) {
                            case "Kgs":
                              _defaultWeightUnit = "Lbs";
                              break;
                            case "Lbs":
                              _defaultWeightUnit = "Lvl";
                              break;
                            case "Lvl":
                              _defaultWeightUnit = "Kgs";
                              break;
                          }
                          setState(() {});
                          var exer = widget.exercise.toMap();
                          exer['weightUnit'] = _defaultWeightUnit;
                          _exerciseBloc.valUpdate(Exercise.fromMap(exer));
                        },
                      ),
                    ),
                  ),
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
                      return WorkSetItem(
                        set: _workSet,
                        exercise: widget.exercise,
                      );
                    }, childCount: _wSets?.length),
                  ),
                ],
              ),
              //ADD BUTTON
              FlatButton(
                child: Text("Add Set"),
                onPressed: () {
                  //GET UPDATED WORKSETS AFTER EXERCISE UPDATE
                  var lastSetId = int.tryParse(_wSets.last.set.toString());
                  lastSetId++;
                  _wSets.add(WorkSet(set: lastSetId.toString()));
//
                  _exerciseBloc.addWorkSet(widget.exercise).then((newExercise) {
                    setState(() {});
                  });

                  //UPDATE THE WORKSET LIST BY ADDING ONE WORKSET
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
