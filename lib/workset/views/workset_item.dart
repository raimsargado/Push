import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_widgets/flutter_widgets.dart';
import 'package:strongr/exercise/bloc/exercise_bloc_api.dart';
import 'package:strongr/exercise/models/exercise.dart';
import 'package:strongr/service_init.dart';
import 'package:strongr/workout/models/workout.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetItem extends StatefulWidget {
  final WorkSet workSet;
  final Exercise exercise;
  final Workout workout;

  const WorkSetItem({Key key, this.workSet, this.exercise, this.workout})
      : super(key: key);

  @override
  _WorkSetItemState createState() => _WorkSetItemState();
}

class _WorkSetItemState extends State<WorkSetItem> {
  //
  bool _checkboxTag;

  var _setFieldController = TextEditingController();
  var _recentFieldController = TextEditingController();
  var _weightFieldController = TextEditingController();
  var _repsFieldController = TextEditingController();

  var _exerciseBloc = serviceLocator.get<ExerciseBlocApi>();

  Timer _debounce;

  String _workSetText;

  var TAG = "WORKSET ITEM";

  @override
  // ignore: must_call_super
  void initState() {
    //
    var wSet = widget.workSet;
    _workSetText = wSet.set;
    _recentText = wSet.recent ?? "";
    _weightText = wSet.weight ?? "";
    _repsText = wSet.reps ?? "";
    _checkboxTag = wSet.tag ?? false;

    ///
    _workSetText = _workSetText;
    _recentFieldController.text = _recentText;
    _weightFieldController.text = _weightText;
    _repsFieldController.text = _repsText;

    ///
    _setFieldController.addListener(_onChange);
    _recentFieldController.addListener(_onChange);
    _weightFieldController.addListener(_onChange);
    _repsFieldController.addListener(_onChange);
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key("unique key"),
      onVisibilityChanged: (VisibilityInfo info) {
        print("$TAG ${info.visibleFraction} of my widget is visible");
        print("$TAG SET : ${widget.workSet.toMap()} ");
      },
      child: GestureDetector(
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
              Expanded(flex: 1, child: Center(child: Text(_recentText))),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          alignLabelWithHint: true, hintText: ""),
                      controller: _weightFieldController,
//                    focusNode: _weightFieldFocus,
                      inputFormatters: <TextInputFormatter>[
                        WhitelistingTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3)
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
//                  focusNode: _repsFieldFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3)
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
                        _onChange();
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _setFieldController.removeListener(_onChange);
    _recentFieldController.removeListener(_onChange);
    _weightFieldController.removeListener(_onChange);
    _repsFieldController.removeListener(_onChange);
  }

  String _recentText;
  String _weightText;
  String _repsText;

  void _onChange() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _workSetText = _workSetText;
      _recentText = _recentFieldController.text.trim() ?? _recentText;
      _weightText = _weightFieldController.text.trim() ?? _weightText;
      _repsText = _repsFieldController.text.trim() ?? _repsText;
      _exerciseBloc.updateWorkSet(
          widget.exercise,
          WorkSet(
            set: _workSetText,
            recent: _recentText,
            weight: _weightText,
            reps: _repsText,
            tag: _checkboxTag,
          ),
          widget.workout);
    });
  }
}
