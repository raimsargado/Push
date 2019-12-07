import 'package:flutter/material.dart';
import 'package:strongr/workset/models/workset.dart';

class WorkSetItem extends StatelessWidget {
  final WorkSet set;

  const WorkSetItem({Key key, this.set}) : super(key: key);

//todo create exercise item
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: Container(
          height: 69,
          child: Center(
            child: Text(""),
          ),
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
