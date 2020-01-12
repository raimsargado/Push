import 'package:flutter/material.dart';
import 'package:strongr/home/home_view.dart';
import 'package:strongr/service_init.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  serviceInit();
  runApp(HomeView());
}


//TODO ENABLE DONE STATUS
//TODO FIX SPACING
//TODO MODIFY WEIGHT COLUMN .. MAKE THE TITLE TO BE KGS/LBS/RESISTANCE
//TODO START WORKOUT AND (OPTIONAL) PUT TIMER
//TODO UPDATE RECENT COLUMN ON FINISHED WORKOUT
