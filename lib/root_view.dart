import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/main.dart';
import 'package:strongr/models/exercise.dart';
import 'package:strongr/models/workset.dart';

class RootView extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    var _exerciseProvider = Provider.of<ExerciseBloc>(context);

    var _exercises = List<Exercise>();
    _exercises.add(Exercise("PUSH DAY"));
    _exercises.add(Exercise("PULL DAY"));
    _exercises.add(Exercise("CORE DAY"));
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: Scaffold(
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            size: 40,
          ),
          onPressed: () {
            _exerciseProvider.valController.sink.add(Exercise("Leg Day"));
          },
        ),
        appBar: AppBar(
          title: Text("Strongr"),
          elevation: 0,
        ),
        body: StreamBuilder<Exercise>(
          initialData: Exercise("initial"),
            stream: _exerciseProvider.exerciseOutput,
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
                          }, childCount: _exercises?.length)),
                ],
              );
            }
        ),
      ),
    );
  }
}

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;

  ExerciseItem({this.exercise});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(exercise.name),
      onTap: (){
        //todo onTap implement
      },
    );
  }
}

class WorkSetItem extends StatelessWidget {
  final WorkSet set;

  const WorkSetItem({Key key, this.set}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(set.previous),
    );
  }
}
