import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: CustomColors().primary,
      errorColor: CustomColors().error,
      disabledColor: CustomColors().disabled,
      scaffoldBackgroundColor: CustomColors().offWhite,
      fontFamily: GoogleFonts.montserrat().fontFamily,
    );
  }
}

class CustomColors {
  final Color primary = const Color.fromARGB(255, 60, 91, 250);
  final Color secondary = const Color.fromARGB(255, 22, 22, 22);
  final Color error = const Color.fromARGB(255, 250, 60, 106);
  final Color success = const Color.fromARGB(255, 0, 186, 136);
  final Color disabled = const Color.fromARGB(255, 217, 217, 217);
  final Color textDisplay = const Color.fromARGB(255, 22, 22, 22);
  final Color subText = const Color.fromARGB(255, 182, 182, 182);
  final Color night = const Color.fromARGB(255, 22, 22, 22);
  final Color grey = const Color.fromARGB(255, 182, 182, 182);
  final Color offWhite = const Color.fromARGB(255, 245, 245, 245);
}
