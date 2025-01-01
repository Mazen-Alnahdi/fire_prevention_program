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

    // Regex to allow negative or positive numbers with decimals
    final regex = RegExp(r'^-?\d*\.?\d*$');
    if (regex.hasMatch(text)) {
      // Check for only one sign at the beginning and one decimal point
      if (
          text.indexOf('-') > 0 ||
          text.indexOf('+') > 1 ||
          text.indexOf('.') != text.lastIndexOf('.')) {
        return oldValue; // Revert to the previous value if invalid sign or dot usage
      }

      // Parse the value as a double to check the range
      final numValue = double.tryParse(text);

      // If the parsed value is valid and within the allowed range, return the new value
      if (numValue == null ) {
        return newValue;

      }
      if(numValue >= -100 && numValue <= 100){
        return newValue;
      }
    }

    // If input is invalid or out of range, return the old value
    return oldValue;
  }
}
