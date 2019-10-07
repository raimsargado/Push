import 'package:flutter/material.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/views/workout_view.dart';

class WorkoutItem extends StatelessWidget {
  final Workout workout;

  WorkoutItem({this.workout});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Container(
          margin: EdgeInsets.all(24.0),
          child: Center(
            child: Text(workout.name),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutView(workout: workout),
            ),
          );
        },
      ),
    );
  }
}
