import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push/workout/views/workout_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _isNightMode = false;
  Future<bool> _themeFuture;
  SharedPreferences _prefs;

  @override
  void initState() {
    //init prefs
    _themeFuture = SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      return _getTheme();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _themeFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null &&
              snapshot.connectionState != ConnectionState.done) {
            return Center(child: CircularProgressIndicator());
          } else {
            _isNightMode = snapshot.data;
            return MaterialApp(
              title: 'Flutter Demo',
              theme: _isNightMode ? ThemeData.dark() : ThemeData.light(),
              home: WorkoutListView(
                themeCallback: () => _changeTheme(),
              ), /**[WorkoutListView] as home page**/
            );
          }
        });
  }

  Future<bool> _getTheme() async {
    return await Future.value((_prefs.getBool("THEME") ?? false));
  }

  _changeTheme() {
    _prefs.setBool("THEME", _isNightMode ? false : true).then((_) {
      setState(() {
        _themeFuture = SharedPreferences.getInstance().then((prefs) {
          _prefs = prefs;
          return _getTheme();
        });
      });
    });
  }
}
