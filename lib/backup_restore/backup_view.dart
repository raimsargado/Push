import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push/app_db_interface.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupView extends StatefulWidget {
  final Function() refreshCallback;

  const BackupView({Key key, this.refreshCallback})
      : super(key: key);

  @override
  _BackupViewState createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  var dbKeys = "DB"; // main key for prefs on db identifiers
  var TAG = "BackupView";
  var _backups = List<String>(); // list of db identifiers
  Future<List<String>> _futureBackups;
  var _workoutBloc = serviceLocator.get<WorkoutBlocApi>();

  Future<Database> get _database async =>
      await serviceLocator.get<AppDatabaseApi>().database;
  var dbFunctions = serviceLocator.get<AppDatabaseApi>();

  SharedPreferences _prefs;

  @override
  void initState() {
    //init prefs
    _futureBackups = SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      return _getBackupList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Backup/Restore"),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_backup_restore),
            onPressed: () async {
              var oldBackups = _prefs.getStringList(dbKeys);
              _backups.clear();
              _backups.addAll(oldBackups);
              var dateKey = DateTime.now().toString();
              var dataAsText = await dbFunctions.backup();
              dbFunctions.write(dataAsText, dateKey).then((_) {
                _backups.add(dateKey);
                //save key to prefs
                _prefs.setStringList(dbKeys, _backups).then((_) {
                  setState(() {
                    _futureBackups =
                        SharedPreferences.getInstance().then((prefs) {
                      _prefs = prefs;
                      return (prefs.getStringList(dbKeys) ?? List<String>());
                    });
                  });
                });
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.delete_sweep),
            onPressed: () {
              //
              var oldBackups = _prefs.getStringList(dbKeys);
              oldBackups.forEach((backupKey) {
                //delete
                dbFunctions.delete(backupKey).then((result) {
                  print("deleted file: result: $result");
                });
                _backups.remove(backupKey);
              });
              _prefs.setStringList(dbKeys, _backups).then((_) {
                setState(() {
                  _futureBackups =
                      SharedPreferences.getInstance().then((prefs) {
                    _prefs = prefs;
                    return (prefs.getStringList(dbKeys) ?? List<String>());
                  });
                });
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: _futureBackups,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          print("$TAG  , snapshots: ${snapshot.data}");
          print("$TAG  , snapshots: connection ${snapshot.connectionState}");
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(image: AssetImage('assets/MoshingDoodle.png')),
                    Text("No back ups."),
                    CupertinoButton(
                      child: Text("MAKE BACKUP"),
                      onPressed: () async {
                        var dateKey = DateTime.now().toString();
                        var dataAsText = await dbFunctions.backup();
                        dbFunctions.write(dataAsText, dateKey).then((_) {
                          //save key to prefs
                          _prefs.setStringList(dbKeys, [dateKey]).then((_) {
                            setState(() {
                              _futureBackups =
                                  SharedPreferences.getInstance().then((prefs) {
                                _prefs = prefs;
                                return (prefs.getStringList(dbKeys) ??
                                    List<String>());
                              });
                            });
                          });
                        });
                      },
                    ),
                  ],
                ),
              );
            } else {
              _backups = snapshot.data;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      var backup = _backups?.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                        child: ListTile(
                          title: Text(backup),
                          onTap: () async {
                            await dbFunctions
                                .read(backup)
                                .then((dataAsText) async {
                              print("text from file backupDateKey: $backup");
                              print(
                                  "text from file: dataAsText: ${dataAsText}");
                              await dbFunctions.restore(dataAsText).then((_){
                                widget.refreshCallback();
                              });
                            });
                          },
                        ),
                      );
                    }, childCount: _backups?.length),
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }

  void _displayBackupRestoreDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            title: Text('Backup/Restore'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text("Backup present programs"),
                    IconButton(
                      icon: Icon(Icons.save),
                      onPressed: () {
                        //
                      },
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text("Restore previous programs"),
                    IconButton(
                      icon: Icon(Icons.restore),
                      onPressed: () {
                        //
                      },
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('OK'),
                onPressed: () {
                  //go back to previous page
                  Navigator.pop(context);
                  //toast "changes not saved"
                },
              ),
            ],
          );
        });
  }

  Future<List<String>> _getBackupList() async {
    return await Future.value((_prefs.getStringList(dbKeys) ?? List<String>()));
  }
}
