import 'package:flutter/services.dart';
import 'package:strings/strings.dart';

class PascalCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    var pascalText = camelize(newValue.text?.toString());
    return TextEditingValue(
      text: pascalText,
      selection: newValue.selection,
    );
  }
}