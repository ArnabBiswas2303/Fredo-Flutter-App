import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Color kolor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll('#', '');

  if (hexColor.length == 6) {
    hexColor = 'FF' + hexColor;
  }

  return Color(int.parse(hexColor, radix: 16));
}

thatBlueColor() {
  // return kolor("#282860");
  return Colors.black;
}

barkolor() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));
}

mainKolor() {
  return kolor("#2FE388");
}

colorList() {
  return [
    "#fd9644",
    "#fed330",
    "#26de81",
    "#2bcbba",
    "#eb3b5a",
    "#fa8231",
    "#f7b731",
    "#20bf6b",
    "#0fb9b1",
    "#45aaf2",
    "#4b7bec",
    "#a55eea",
    "#d1d8e0",
    "#778ca3",
    "#2d98da",
    "#3867d6",
    "#8854d0",
    "#a5b1c2",
    "#4b6584",
  ];
}
