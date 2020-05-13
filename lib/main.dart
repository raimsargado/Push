import 'package:flutter/material.dart';
import 'package:push/home/home_view.dart';
import 'package:push/service_init.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  serviceInit();
  runApp(HomeView());
}
