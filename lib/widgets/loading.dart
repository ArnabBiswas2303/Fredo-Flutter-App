import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

loading(BuildContext context) {
  return Container(
    color: Colors.black.withOpacity(0.6),
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitRing(
                color: Colors.black,
                lineWidth: 2,
                size: 30,
              ),
              SizedBox(width: 10),
              Text(
                "Loading",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      ],
    ),
  );
}
