import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:push/app_db_interface.dart';
import 'package:push/reusables/dialogs.dart';
import 'package:push/service_init.dart';
import 'package:push/workout/bloc/workout_bloc_api.dart';
import 'package:sembast/sembast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupView extends StatefulWidget {
  final Function() refreshCallback;

  const BackupView({Key key, this.refreshCallback}) : super(key: key);

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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Backup/Restore",
                      style: TextStyle(
                        fontFamily: 'Helvetica Neue',
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings_backup_restore),
                  onPressed: () async {
                    var decision = await Dialogs.decisionDialog(
                      context,
                      "Backup/Restore",
                      "Make backup?",
                      "Yes",
                      "No",
                    );
                    if (decision == DialogAction.positive) {
                      _makeBackup();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete_sweep),
                  onPressed: () async {
                    var decision = await Dialogs.decisionDialog(
                      context,
                      "Backup/Restore",
                      "Delete all backups?",
                      "Yes",
                      "No",
                    );
                    if (decision == DialogAction.positive) {
                      _deleteAllBackups();
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: FutureBuilder<List<String>>(
                future: _futureBackups,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  print("$TAG  , snapshots: ${snapshot.data}");
                  print(
                      "$TAG  , snapshots: connection ${snapshot.connectionState}");
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.data.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "No backups.",
                              style:
                              TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            CupertinoButton(
                              child: Text("MAKE BACKUP"),
                              onPressed: () async {
                                var decision = await Dialogs.decisionDialog(
                                  context,
                                  "Backup/Restore",
                                  "Make backup?",
                                  "Yes",
                                  "No",
                                );
                                if (decision == DialogAction.positive) {
                                  _makeBackup();
                                }
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
                                    var decision = await Dialogs.decisionDialog(
                                      context,
                                      "Backup/Restore",
                                      "Are you sure to restore? This will replace your current workouts.",
                                      "Yes",
                                      "No",
                                    );
                                    if (decision == DialogAction.positive) {
                                      _restore(backup);
                                    }
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
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> _getBackupList() async {
    return await Future.value((_prefs.getStringList(dbKeys) ?? List<String>()));
  }

  Future<void> _makeBackup() async {
    var oldBackups = _prefs.getStringList(dbKeys);
    _backups.clear();
    _backups.addAll(oldBackups ?? List<String>());
    var dateKey = DateTime.now().toString();
    var dataAsText = await dbFunctions.backup();
    dbFunctions.write(dataAsText, dateKey).then((_) {
      _backups.add(dateKey);
      //save key to prefs
      _prefs.setStringList(dbKeys, _backups).then((_) {
        setState(() {
          _futureBackups = SharedPreferences.getInstance().then((prefs) {
            _prefs = prefs;
            return (prefs.getStringList(dbKeys) ?? List<String>());
          });
        });
      });
    });
  }

  void _deleteAllBackups() {
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
        _futureBackups = SharedPreferences.getInstance().then((prefs) {
          _prefs = prefs;
          return (prefs.getStringList(dbKeys) ?? List<String>());
        });
      });
    });
  }

  Future<void> _restore(String backup) async {
    await dbFunctions.read(backup).then((dataAsText) async {
      print("text from file backupDateKey: $backup");
      print("text from file: dataAsText: ${dataAsText}");
      await dbFunctions.restore(dataAsText).then((_) {
        widget.refreshCallback();
      });
    });
  }
}
