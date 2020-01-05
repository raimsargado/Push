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
  var _weightFieldController = TextEditingController();

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
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
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
                      child: Text(widget.exercise.name),
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
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                      child: Center(child: Text("SET")),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                      child: Center(child: Text("RECENT")),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: TextField(
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              alignLabelWithHint: true, hintText: "kg/lbs"),
                          controller: _weightFieldController,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                      child: Center(child: Text("REPS")),
                    ),
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
                      var _workSet = widget.exercise.workSets?.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                        child: WorkSetItem(set: WorkSet.fromMap(_workSet)),
                      );
                    }, childCount: widget.exercise.workSets?.length),
                  ),
                ],
              ),
              //ADD BUTTON
              FlatButton(
                child: Text("Add Set"),
                onPressed: () {
                  //GET EXISTING WORKSET FROM EXERCISE BLOC
                  _exerciseBloc.addWorkSet(widget.exercise);

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
