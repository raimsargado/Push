import 'package:flutter/material.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workout/views/workout_view.dart';

class WorkoutItem extends StatelessWidget {
  final Workout workout;

  WorkoutItem({this.workout});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutView(workout: workout),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(height: 69, child: Center(child: Text(workout.name))),
      ),
    );
  }
}
