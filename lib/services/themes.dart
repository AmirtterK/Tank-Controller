import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true, 
  colorScheme: ColorScheme.light(
    secondary:  Color.fromARGB(255, 0, 210, 190),
   
  )
);
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    secondary:  Color.fromARGB(255, 0, 210, 190),
  
    )
);
