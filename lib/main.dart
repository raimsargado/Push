import 'package:flutter/material.dart';
import 'package:strongr/home/home_view.dart';
import 'package:strongr/service/service_init.dart';


void main() {
  serviceInit();
  runApp(HomeView());
}
