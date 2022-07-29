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

  Colour getColourByName(String name) {
    switch (name.toLowerCase()) {
      case 'black':
        return Colour.black;
      case 'white':
        return Colour.white;
      case 'grey':
        return Colour.grey;
      case 'brown':
        return Colour.brown;
      case 'beige':
        return Colour.beige;
      case 'yellow':
        return Colour.yellow;
      case 'blue':
        return Colour.blue;
      case 'green':
        return Colour.green;
      case 'red':
        return Colour.red;
      case 'orange':
        return Colour.orange;
      case 'maroon':
        return Colour.maroon;
      default:
        return Colour.white;
    }
  }

  String name() {
    switch (this) {
      case Colour.black:
        return 'black';
      case Colour.white:
        return 'white';
      case Colour.grey:
        return 'grey';
      case Colour.brown:
        return 'brown';
      case Colour.beige:
        return 'beige';
      case Colour.yellow:
        return 'yellow';
      case Colour.blue:
        return 'blue';
      case Colour.green:
        return 'green';
      case Colour.red:
        return 'red';
      case Colour.orange:
        return 'orange';
      case Colour.maroon:
        return 'maroon';
      default:
        return 'white';
    }
  }
}
