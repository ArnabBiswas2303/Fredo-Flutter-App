import 'dart:async';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  Widget widget1 = SpinKitRing(
    color: Colors.black,
    lineWidth: 2,
    size: 30,
  );
  Widget widget2 = Text("Placing Order..", style: TextStyle(fontSize: 15));
  bool back = false;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      setState(() {
        widget1 = Icon(EvaIcons.checkmarkCircleOutline,
            color: Colors.green, size: 50);
        widget2 = Text("Order Received!", style: TextStyle(fontSize: 20));
        back = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
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
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      widget1,
                      SizedBox(width: 10),
                      widget2,
                    ],
                  ),
                  SizedBox(height: 10),
                  back
                      ? FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Go Back",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          color: Colors.black87,
                        )
                      : SizedBox(height: 0),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
