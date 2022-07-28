import 'package:flutter/material.dart';

enum Colour {
  black,
  white,
  grey,
  brown,
  beige,
  yellow,
  blue,
  green,
  red,
  orange,
  maroon
}

extension ColourExtension on Colour {
  Color get color {
    switch (this) {
      case Colour.black:
        return Colors.black;
      case Colour.white:
        return Colors.white;
      case Colour.grey:
        return Colors.grey;
      case Colour.brown:
        return Colors.brown;
      case Colour.beige:
        return Colors.brown.shade100;
      case Colour.yellow:
        return Colors.yellow;
      case Colour.blue:
        return Colors.blue.shade700;
      case Colour.green:
        return Colors.green;
      case Colour.red:
        return Colors.red;
      case Colour.orange:
        return Colors.orange;
      case Colour.maroon:
        return Colors.redAccent.shade700;
      default:
        return Colors.white;
    }
  }
}
