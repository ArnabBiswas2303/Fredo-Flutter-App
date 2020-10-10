import 'package:flutter/material.dart';
import '../utils/utils.dart';

headerGeneral(x) {
  return AppBar(
    brightness: Brightness.light,
    elevation: 0,
    centerTitle: true,
    titleSpacing: 0,
    title: Text(
      x,
      style: TextStyle(
        fontWeight: FontWeight.w300,
        fontSize: 25,
        color: thatBlueColor(),
      ),
    ),
    iconTheme: new IconThemeData(
      color:
          thatBlueColor(), // using our primary color, can be found in utils class
    ),
    backgroundColor: Colors.white,
  );
}
