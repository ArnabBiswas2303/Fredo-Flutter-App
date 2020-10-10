import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:consumer/auth/auth.dart';
import 'package:consumer/screens/main2.dart';
import 'package:consumer/utils/utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Connectivity connectivity;
  StreamSubscription<ConnectivityResult> subscription;
  String x = "Splash!";
  @override
  void initState() {
    super.initState();
    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        await getUser();
      } else {
        setState(() {
          x = "No Internet!";
        });
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('user');
    if (user == null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return AuthScreen();
      }));
    } else if (user != null) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return Main2(user);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    barkolor();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Center(
              child: x == "No Internet!"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          EvaIcons.wifiOff,
                          size: 40,
                        ),
                        Text(
                          "No Internet",
                          style: TextStyle(
                              fontFamily: 'varela',
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Center(
                      child: Text(
                        "Ghar se Ghar Tak",
                        style: TextStyle(
                          fontFamily: 'varela',
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                        softWrap: true,
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
