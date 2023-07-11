

import 'dart:math';
import 'package:flutter/material.dart';

class FormatDate{
  static TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = _format(newValue.text, '/');
    return newValue.copyWith(text: text, selection: updateCursorPosition(text));
  }

  static String _format(String value, String seperator) {
    value = value.replaceAll(seperator, '');
    var newString = '';

    for (int i = 0; i < min(value.length, 8); i++) {
      newString += value[i];
      if ((i == 1 || i == 3) && i != value.length - 1) {
        newString += seperator;
      }
    }

    return newString;
  }

  static TextSelection updateCursorPosition(String text) {
    return TextSelection.fromPosition(TextPosition(offset: text.length));
  }

  static DateTime stringToDate(String v){
    List values = v.split("/");
    try{
      return DateTime(int.parse(values[2]),int.parse(values[1]),int.parse(values[0]));
    }catch(err){
      return DateTime.now();
    }

  }

  static bool compareDates(DateTime d2,DateTime d1 ){
    return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
  }

  static String dateToString(DateTime v){
    return "${v.day}/${v.month}/${v.year}";
  }
}



class FormatValue{
  static String doubleToString(double number){
    int newNumber = number.toInt();
    return intToString(newNumber);
  }

  static String intToString(int number){
    List numbers = number.toString().split("").reversed.toList();
    List newNumber = List.empty(growable: true);
    for (var i = 0; i < numbers.length; i++) {
      if((i%3) == 0 && i != 0){
        newNumber.add(",");
      }
      newNumber.add(numbers[i]);
    }
    String res = "";
    newNumber = newNumber.reversed.toList();
    newNumber.forEach((e) => res+=e);
    print(res);
    return res;
  }

  static double StringToFormatDouble(String number){
    try {
      return double.parse(number.replaceAll(",", "").replaceAll("\$", ""));
    } catch (e) {
      return 0.0;
    }
  }
}

class FormatText{
  static String toFirstUpperCase(String s){
    try {
      List<String> chars = s.split("");
      chars[0] = chars[0].toUpperCase();
      String res = "";
      chars.forEach((e)=> res +=e);
      return res;
    } catch (e) {
      return s;
    }
    
  }

  static String removeSpaces(String s){
    List<String> chars = s.split("");
    if(chars.isEmpty){
      return s;
    }

    while(true){
      if(chars.length == 1){
        break;}
      if(chars[chars.length-1] == " "){
        chars.removeLast();
      }else{
        break;
      }
    }
    String res = "";
    chars.forEach((e)=> res +=e);
    return res;
  }

}