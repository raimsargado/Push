import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workset/bloc/workset_bloc_api.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetItem extends StatefulWidget {
  final WorkSet set;
  final Exercise exercise;

  const WorkSetItem({Key key, this.set, this.exercise}) : super(key: key);

  @override
  _WorkSetItemState createState() => _WorkSetItemState();
}

class _WorkSetItemState extends State<WorkSetItem> {
  //
  var _setFieldController = TextEditingController();
  bool _checkboxTag = false; //todo catch the value from exercise object
  var _recentFieldController = TextEditingController();
  var _weightFieldController = TextEditingController();
  var _repsFieldController = TextEditingController();

  var _workSetBloc = serviceLocator.get<WorkSetBlocApi>();
  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  Timer _debounce;

  String _workSetText;

  @override
  // ignore: must_call_super
  void initState() {
    var wSet = widget.set;
    _workSetText = wSet.set;
    _recentFieldController.text = wSet.recent;
    _weightFieldController.text = wSet.weight;
    _repsFieldController.text = wSet.reps;

//    _setFieldController.addListener(_onChange);
    _recentFieldController.addListener(_onChange);
    _weightFieldController.addListener(_onChange);
    _repsFieldController.addListener(_onChange);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
//        margin: EdgeInsets.fromLTRB(4, 8, 16, 4),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(child: Text(_workSetText)),
            ),
            Expanded(
              flex: 1,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration:
                    InputDecoration(alignLabelWithHint: true, hintText: ""),
                controller: _recentFieldController,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(alignLabelWithHint: true, hintText: ""),
                    controller: _weightFieldController,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Icon(
                Icons.clear,
                color: Colors.grey,
                size: 20,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration:
                      InputDecoration(alignLabelWithHint: true, hintText: ""),
                  controller: _repsFieldController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Checkbox(
                  value: _checkboxTag,
                  onChanged: (bool value) {
                    print("onchange $value");
                    setState(() {
                      _checkboxTag = value;
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
//    _setFieldController.removeListener(_onChange);
    _recentFieldController.removeListener(_onChange);
    _weightFieldController.removeListener(_onChange);
    _repsFieldController.removeListener(_onChange);
  }

  void _onChange() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      _exerciseBloc.updateWorkSet(
        widget.exercise,
        WorkSet(
          set: _workSetText,
          recent: _recentFieldController.text.trim(),
          weight: _weightFieldController.text.trim(),
          reps: _repsFieldController.text.trim(),
        ),
      );
    });
//
//    newWorkoutName = _textController.text;
//    print("orig workout name ${widget.workout.name}");
//
//    print("onChange haschanges ${_hasChanges()}");
//    if (_hasChanges()) {
//
//    } else {
//      setState(() {
//        _exerciseBloc.initExercises(widget.workout.name);
//      });
//    }
  }
}
