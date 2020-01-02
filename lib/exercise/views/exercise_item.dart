import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  var _worksetBloc = serviceLocator.get<WorkSetBlocApi>();
  var _weightFieldController = TextEditingController();

  @override
  void initState() {
//    _textController.addListener(_onChange);
//    _textFocus.addListener(_onChange);
//    _textController.text = widget.workout.name;
    _worksetBloc.initWorkSets(widget.workout.name, widget.exercise.name);
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
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
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
                    icon: Icon(Icons.settings),
                    onPressed: () => null,
                  )
                ],
              ),
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
              StreamBuilder(
                stream: _worksetBloc.valOutput,
                builder: (context, snapshot) {
                  print("exercise item snapshot data: ${snapshot.data}");
                  if (snapshot.data == null) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    var worksets = snapshot.data as List<WorkSet>;
                    print("home_view workouts: ${worksets.length}");
                    if (worksets.isNotEmpty) {
                      var wList = worksets.toSet().toList();
                      return CustomScrollView(
                        shrinkWrap: true,
                        slivers: <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                              var _workSet = wList?.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                                child: WorkSetItem(set: _workSet),
                              );
                            }, childCount: wList?.length),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: WorkSetItem(set: WorkSet()),
                      );
                    }
                  }
                },
              ),
              FlatButton(
                child: Text("Add Set"),
                onPressed: () {
                  _worksetBloc.valCreate(WorkSet());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
