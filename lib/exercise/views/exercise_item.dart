import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:strongr/exercise/models/exercise.dart';

class ExerciseItem extends StatelessWidget {
  final Exercise exercise;

  const ExerciseItem({Key key, this.exercise}) : super(key: key);

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
        child: Container(height: 69, child: Center(child: Text(exercise.name))),
      ),
    );
  }
}
