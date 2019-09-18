
import 'package:flutter/material.dart';
import 'package:strongr/models/workset.dart';

class WorkSetItem extends StatelessWidget {
  final WorkSet set;

  const WorkSetItem({Key key, this.set}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(set.id),
      title: Text(set.previous),
      trailing: Text(set.tag),
    );
  }
}
