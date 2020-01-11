import 'package:flutter/material.dart';
import 'package:strongr/home/home_view.dart';
import 'package:strongr/service_init.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  serviceInit();
  runApp(HomeView());
}
