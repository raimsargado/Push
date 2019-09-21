import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strongr/workout/bloc/workout_bloc.dart';
import 'package:strongr/workset/bloc/workset_bloc.dart';
import 'package:strongr/root_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(builder: (context) => WorkoutBloc()),
        Provider(builder: (context) => WorkSetBloc()),
      ],
      child: RootView(),
    ),
  );
}
