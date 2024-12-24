
import 'package:flutter/services.dart';

class InputFormat extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue)
  {
    final newText = newValue.text;
    //Allow only one period
    if('.'.allMatches(newText).length <=1){
      return newValue;
    }
    return oldValue;

  }

}