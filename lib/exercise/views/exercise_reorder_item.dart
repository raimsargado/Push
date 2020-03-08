

import 'package:flutter/material.dart';
import 'package:push/exercise/models/exercise.dart';

class ExerciseReorderItem extends StatelessWidget {

  final Exercise exercise;

  const ExerciseReorderItem({Key key, this.exercise}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Container(height: 69, child: Center(child: Text(exercise.name))),
    );
  }
}
