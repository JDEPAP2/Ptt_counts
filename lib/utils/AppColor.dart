import 'package:flutter/material.dart';

class AppColor{
  //Si es entrada es verdadero, si es salida sera falso
  static Color primary = Colors.black;
  static Color secondary = Colors.black;
  static Color light = Colors.black;
  static Color dark = Colors.black;
  static Color black = Colors.black;
  static Color white = Colors.white;
  static LinearGradient gradient = const LinearGradient(colors: [Colors.black]);
  static LinearGradient navGradient = const LinearGradient(colors: [Colors.black]);
  static BoxShadow shadow = const BoxShadow();

  setColors(bool state){

    primary = state? Color.fromARGB(255, 218, 0, 44): const Color.fromARGB(255, 0, 70, 199);
    secondary = state? Color.fromARGB(255, 209, 30, 66): const Color.fromARGB(255, 17, 98, 228);
    light = state? const Color.fromRGBO(255, 62, 100, 1): const Color.fromARGB(255, 44, 126, 250);
    dark = state? Color.fromARGB(255, 78, 6, 21): Color.fromARGB(255, 13, 48, 100);
    black = state? Color.fromRGBO(20, 0, 4, 1): Color.fromARGB(255, 0, 7, 22);  
    white = state? Color.fromRGBO(255, 216, 224, 1): Color.fromARGB(255, 212, 226, 255);   
    gradient = LinearGradient(
    colors: [primary,secondary], 
    begin: Alignment.centerLeft,
    end: Alignment.centerRight
    );
    navGradient = LinearGradient(
    colors: [primary.withOpacity(0.2),Colors.transparent], 
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter
    );

    shadow = BoxShadow(
      color: black.withOpacity(0.5),
      blurRadius: 4,
      spreadRadius: 3,
      offset: const Offset(1,2)
    );

  }

  getPrimary(bool state){
    return state? Color.fromARGB(255, 218, 0, 44): const Color.fromARGB(255, 0, 70, 199);
  }
}
