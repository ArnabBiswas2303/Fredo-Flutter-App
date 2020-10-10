import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

circularProgress() {
  return SpinKitPulse(
    color: Colors.black.withOpacity(0.7),
    size: 50,
    duration: Duration(milliseconds: 500),
  );
}

circularProgress2() {
  return SpinKitRing(
    lineWidth: 2,
    color: Colors.black.withOpacity(0.7),
    size: 50,
    duration: Duration(milliseconds: 1000),
  );
}

Container linearProgress() {
  return Container(
    padding: EdgeInsets.only(bottom: 10.0),
    child: LinearProgressIndicator(
      backgroundColor: Colors.white,
      valueColor: AlwaysStoppedAnimation(Colors.black),
    ),
  );
}
