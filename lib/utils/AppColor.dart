import 'package:flutter/material.dart';

class AppColor{
  //Si es ingreso es verdadero, si es egreso sera falso
  static Color primary = Colors.black;
  static Color secondary = Colors.black;
  static Color light = Colors.black;
  static Color dark = Colors.black;
  static Color black = Colors.black;
  static LinearGradient gradient = const LinearGradient(colors: [Colors.black]);
  static BoxShadow shadow = const BoxShadow();

  setColors(bool state){

    primary = state? const Color.fromARGB(255, 206, 29, 16): const Color.fromARGB(255, 0, 70, 199);
    secondary = state? const Color.fromARGB(255, 220, 51, 9): const Color.fromARGB(255, 17, 98, 228);
    light = state? const Color.fromARGB(255, 255, 62, 48): const Color.fromARGB(255, 44, 126, 250);
    dark = state? const Color.fromARGB(255, 97, 10, 4): Color.fromARGB(255, 13, 48, 100);
    black = state? Color.fromARGB(255, 19, 1, 0): Color.fromARGB(255, 0, 7, 22);   
    gradient = LinearGradient(
    colors: [primary,secondary], 
    begin: Alignment.centerLeft,
    end: Alignment.centerRight
    );

    shadow = BoxShadow(
      color: state? const Color.fromARGB(255, 31, 6, 0): const Color.fromARGB(255, 3, 0, 30),
      blurRadius: 5,
      spreadRadius: 5,
      offset: const Offset(5,5)
    );

  }



}
