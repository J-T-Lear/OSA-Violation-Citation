import 'package:flutter/material.dart';

class SystemTheme {
  ThemeData themedata = ThemeData(
      colorSchemeSeed: const Color.fromARGB(255, 34, 48, 95),
      scaffoldBackgroundColor: Colors.white,
      textTheme: const TextTheme( 
        bodyLarge: TextStyle(
          color: Colors.red,
        ),
        bodyMedium: TextStyle(    ////Standard text
          color: Colors.black,
        ), 
      ));
}
 
