import 'package:flutter/services.dart';

class AltInputFormat extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty text
    if (text.isEmpty) {
      return newValue;
    }

    // Validate the text
    final regex = RegExp(r'^[-+]?\d*\.?\d*$');
    if (regex.hasMatch(text)) {
      // Ensure only one sign at the beginning and one decimal dot
      if (text.indexOf('-') > 0 || text.indexOf('+') > 0 || text.indexOf('.') != text.lastIndexOf('.')) {
        return oldValue; // Revert to the previous value
      }
      return newValue;
    }

    // If the input doesn't match, revert to the previous value
    return oldValue;
  }
}