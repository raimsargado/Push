import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackupView extends StatefulWidget {
  @override
  _BackupViewState createState() => _BackupViewState();
}

class _BackupViewState extends State<BackupView> {
  var dbKeys = "DB";
  var TAG = "BackupView";
  var _backups = List<String>();
  Future<List<String>> _futureBackups;

  SharedPreferences _prefs;

  @override
  void initState() {
    //init prefs
    _futureBackups = SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
      return (prefs.getStringList(dbKeys) ?? List<String>());
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
            onPressed: () {
              var oldBackups = _prefs.getStringList(dbKeys);
              _backups.clear();
              _backups.addAll(oldBackups);
              _backups.addAll([
                "First Backup",
                "Second Backup",
              ]);
              _prefs.setStringList(dbKeys, _backups).then((_) {
                setState(() {});
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
                      onPressed: () {
                        _prefs.setStringList(dbKeys, [
                          "First Backup",
                          "Second Backup",
                        ]).then((_) {
                          setState(() {});
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
    return await Future.value(_backups);
  }
}
