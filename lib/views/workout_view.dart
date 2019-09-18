import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/main.dart';
import 'package:strongr/models/workout.dart';
import 'package:strongr/models/workset.dart';
import 'package:strongr/views/workset_item.dart';

class WorkoutView extends StatelessWidget {
  final Workout workout;

  WorkoutView({this.workout});

  @override
  Widget build(BuildContext context) {
    var _worksetProvider = Provider.of<WorkSetBloc>(context);
    //get workout name
    //join workout name to list of workset item
    var _worksets = List<WorkSet>();
    _worksets.add(WorkSet("1","previous","5lbs","x10","not done"));
    _worksets.add(WorkSet("1","previous","5lbs","x10","not done"));
    _worksets.add(WorkSet("1","previous","5lbs","x10","not done"));
    _worksets.add(WorkSet("1","previous","5lbs","x10","not done"));
    return Scaffold(
      floatingActionButton: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          size: 40,
        ),
        onPressed: () {
          _worksetProvider.valController.sink.add(WorkSet("1","previous","5lbs","x10","not done"));
        },
      ),
      appBar: AppBar(
        centerTitle: false,
        title: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  hintText: workout.name
                ),
               ),
            ),
            Expanded(
              flex: 0,
              child: IconButton(icon: Icon(Icons.directions_run), onPressed: () {},),
            )

          ],
        ),
      ),
      body: StreamBuilder<WorkSet>(
        initialData: WorkSet("1","previous","5lbs","x10","not done"),
        stream: _worksetProvider.valOutput,
        builder: (context, snapshot) {
          _worksets.add(snapshot.data);
          return CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate:
                    SliverChildBuilderDelegate((BuildContext context, int index) {
                  var _workset = _worksets?.elementAt(index);
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                    child: WorkSetItem(set: _workset),
                  );
                }, childCount: _worksets?.length),
              ),
            ],
          );
        }
      ),
    );
  }
}
