import 'package:flutter/material.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetItem extends StatefulWidget {
  final WorkSet set;

  const WorkSetItem({Key key, this.set}) : super(key: key);

  @override
  _WorkSetItemState createState() => _WorkSetItemState();
}

class _WorkSetItemState extends State<WorkSetItem> {
  //
  var _weightFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(alignLabelWithHint: true, hintText: ""),
                  controller: _weightFieldController,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(alignLabelWithHint: true, hintText: ""),
                  controller: _weightFieldController,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.text,
                    decoration:
                        InputDecoration(alignLabelWithHint: true, hintText: ""),
                    controller: _weightFieldController,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0, 0, 0),
                child: TextField(
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  decoration:
                      InputDecoration(alignLabelWithHint: true, hintText: ""),
                  controller: _weightFieldController,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Checkbox(
                  value: false,
                  onChanged: (bool value) {
                    print("onchange $value");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );

//
//    return ListTile(
//      leading: Text(set.id),
//      title: Text(set.previous),
//      trailing: Text(set.tag),
//    );
  }
}
