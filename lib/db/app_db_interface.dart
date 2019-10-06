import 'package:sembast/sembast.dart';

abstract class AppDatabaseInterface{
  Future<Database> get database;
}