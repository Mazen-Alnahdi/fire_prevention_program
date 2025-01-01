import 'package:flutter/services.dart';

class InputFormat extends TextInputFormatter {
  final double min, max;
  final bool negative;

  InputFormat({
    required this.min,
    required this.max,
    required this.negative,
  });

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;

    // Allow empty text
    if (text.isEmpty) {
      return newValue;
    }

    // Define regex based on the `negative` flag
    final regex = negative
        ? RegExp(r'^-?\d*\.?\d*$') // Allows negative and positive numbers with decimals
        : RegExp(r'^\d*\.?\d+$'); // Allows only positive numbers with decimals

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
      if(numValue >= min && numValue <= max){
        return newValue;
      }
    }

    // If input is invalid or out of range, return the old value
    return oldValue;
  }
}
