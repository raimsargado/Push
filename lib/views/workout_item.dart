
import 'package:flutter/material.dart';
import 'package:strongr/models/workout.dart';
import 'package:strongr/views/workout_view.dart';

class WorkoutItem extends StatelessWidget {
  final Workout workout;

  WorkoutItem({this.workout});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(workout.name),
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => WorkoutView(workout: workout)),
        );
      },
    );
  }
}
