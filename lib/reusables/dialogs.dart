import 'package:flutter/material.dart';

enum DialogAction { positive, negative }

class Dialogs {

  static Future<DialogAction> decisionDialog(
      BuildContext context,
      String title,
      String body,
      String positiveText,
      String negativeText,
      ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(body),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.negative),
              child: Text(negativeText),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.positive),
              child: Text(positiveText),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.negative;
  }
}