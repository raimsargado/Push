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
  var newWorkSets = List<WorkSet>();
  String _defaultWeightUnit;

  var TAG = "EXER ITEM";

  Exercise _exercise;

  bool _isFromBlocUpdate = false;

  @override
  void initState() {
//    if (!_isFromBlocUpdate) {
      _exercise = widget.exercise;
      print("$TAG exercise: ${widget.exercise.toMap()}");
      _exercise.workSets.forEach((workSetMap) {
        _wSets.add(WorkSet.fromMap(workSetMap));
      });
      _wSets.sort(
        (a, b) => a.set.toString().compareTo(b.set.toString()),
      );
      _defaultWeightUnit = _exercise.weightUnit;
//    }
  }


  @override
  void didUpdateWidget(ExerciseItem oldWidget) {
    print("did update widget widget.exercise : ${widget.exercise.toMap()}");
    _exercise = widget.exercise;
    print("$TAG exercise: ${widget.exercise.toMap()}");
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
  Widget build(BuildContext context) {
    _wSets?.forEach((w){
      print("$TAG updated wsets : ${w.toMap()}");
    });
    return GestureDetector(
      onTap: () {
        print("c: ontap");
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
              //listview
//              ListView.builder(
//                  physics: NeverScrollableScrollPhysics(),
//                  shrinkWrap: true,
//                  itemCount: _wSets?.length,
//                  itemBuilder: (BuildContext context, int position) {
//                    var _workSet = _wSets?.elementAt(position);
//                    return WorkSetItem(
//                      set: _workSet,
//                      exercise: widget.exercise,
//                    );
//                  }),
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
                        key: Key(_workSet.set),
                        onDismissed: (direction) {
                          //
                          _wSets.removeAt(index);
                          _wSets.forEach((w){
                            print("DELETE: AFTER REMOVED ; set: ${w.toMap()}");
                          });
                          _exerciseBloc
                              .deleteWorkSet(
                              _exercise, _workSet, widget.workout);
//                          _exerciseBloc
//                              .deleteWorkSet(_exercise, _workSet, widget.workout)
//                              .then((newExercise) {
//                                //
//                            _exercise = newExercise;
//                            print("DELETE: AFTER REMOVED then ; clear ${_exercise.workSets}");
//                            var newSets = newExercise.workSets?.length;
//                            print("DELETE: AFTER REMOVED then ; clear newExercise.workSets $newSets");
////                            _exercise.workSets.addAll(newSets);
//                            print("DELETE: AFTER REMOVED then ; ${_exercise.workSets}");
//                            setState(() {
//                              _isFromBlocUpdate = true;
//                            });
//                          });


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
                  //GET UPDATED WORKSETS AFTER EXERCISE UPDATE
                  String weightHint;
                  String repsHint;

                  print("$TAG add set : current sets : ${_wSets.length}");
                  if (_wSets.isNotEmpty) {
                    var lasWorkSet = _wSets.last;
                    var lastSetId = int.tryParse(lasWorkSet.set.toString());
                    lastSetId++;
                    weightHint = lasWorkSet.weight ?? "";
                    repsHint = lasWorkSet.reps ?? "";
                    _wSets.add(
                      WorkSet(
                        set: lastSetId.toString(),
                        weight: weightHint,
                        reps: repsHint,
                      ),
                    );
//
                  } else {
                    _wSets.add(WorkSet(set: "1"));
                  }

                  _exerciseBloc.addWorkSet(_exercise).then((newExercise) {
                    _wSets.clear();
                    _exercise = newExercise;
                    _exercise.workSets.forEach((workSetMap) {
                      _wSets.add(WorkSet.fromMap(workSetMap));
                    });
                    _wSets.sort(
                      (a, b) => a.set.toString().compareTo(b.set.toString()),
                    );
                    _isFromBlocUpdate = true;
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
