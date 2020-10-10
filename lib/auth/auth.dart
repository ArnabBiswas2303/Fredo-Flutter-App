import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer/models/address.dart';
import 'package:consumer/models/consumer.dart';
import 'package:consumer/screens/data.dart';
import 'package:consumer/screens/main2.dart';
import 'package:consumer/screens/progress.dart';
import 'package:consumer/utils/utils.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flag/flag.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase_ref.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  String phoneNo;
  String smsCode;
  String verificationId;
  bool userCheck = false;
  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      setState(() {
        x = 0;
        Timer(Duration(seconds: 3), () {
          instant = 1;
        });
      });
    };

    final PhoneVerificationCompleted verificationSuccess =
        (AuthCredential credential) async {
      signInInstant(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException exception) {};
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91' + this.phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 20),
      verificationCompleted: verificationSuccess,
      verificationFailed: verificationFailed,
    );
  }

  int x = 1;
  int m = 0;
  int instantVerified = 0;
  int instant = 0;

  animatedFields(child1, child2) {
    return AnimatedCrossFade(
      alignment: Alignment.center,
      firstCurve: Curves.easeIn,
      secondCurve: Curves.easeOut,
      sizeCurve: Curves.bounceOut,
      crossFadeState:
          x == 1 ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 1000),
      firstChild: child1,
      secondChild: child2,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  phoneNumberField() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 10, top: 5),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kolor("#b8e994").withOpacity(0.2),
              ),
              child: Flags.getFlag(country: "IN", height: 20, width: 20),
            ),
            Expanded(
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  filled: true,
                  fillColor: kolor("#b8e994").withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(00000000)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: Color(00000000)),
                  ),
                  hintText: "Enter Phone",
                  hintStyle: TextStyle(
                    fontFamily: "varela",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.6),
                  fontSize: 16,
                  fontFamily: "varela",
                ),
                keyboardType: TextInputType.number,
                autovalidate: true,
                onChanged: (val) {
                  this.phoneNo = val;
                },
                maxLengthEnforced: true,
                maxLength: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  getIn(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(15),
        onPressed: verifyPhone,
        child: Text(
          "Get in",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.6),
            fontSize: 20,
            fontFamily: "varela",
          ),
        ),
        color: kolor("#b8e994"),
      ),
    );
  }

  userExistSavePrefs(userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userId);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Main2(userId);
    }));
  }

  verify() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 20, right: 20),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        padding: EdgeInsets.all(15),
        onPressed: () {
          FirebaseAuth.instance.currentUser().then((user) async {
            if (user != null) {
              await checkifUserExists(user.uid);
              if (!userCheck) {
                signIn();
              } else {
                userExistSavePrefs(user.uid);
              }
            } else {
              signIn();
            }
          });
        },
        child: Text(
          "Verify",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black.withOpacity(0.6),
            fontSize: 20,
            fontFamily: "varela",
          ),
        ),
        color: kolor("#b8e994"),
      ),
    );
  }

  createUserFirstTime(userId) async {
    await consumerRef.document(userId).setData({
      "cId": userId,
      "phoneNumber": this.phoneNo,
      "timestamp": DateTime.now(),
      "isRegistered": false,
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("user", userId);
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) {
      return Data(
        consumer: Consumer(
          cAddress: Address(city: "", fullAddress: "", pincode: 0, state: ""),
          cBirthDay: "",
          cEmail: "",
          cGender: "",
          cId: "",
          cName: "",
        ),
        doc: userId,
      );
    }));
  }

  checkifUserExists(userId) async {
    DocumentSnapshot doc = await consumerRef.document(userId).get();
    if (doc.data == null) {
      setState(() {
        userCheck = false;
      });
    } else {
      String isRegistered = doc["isRegistered"];
      if (isRegistered == "false") {
        setState(() {
          userCheck = false;
        });
      } else {
        setState(() {
          userCheck = true;
        });
      }
    }
  }

  checkifUserExistsInstant(userId) async {
    DocumentSnapshot doc = await consumerRef.document(userId).get();
    if (doc.data == null) {
      setState(() {
        userCheck = false;
      });
    } else {
      setState(() {
        userCheck = true;
      });
    }
  }

  signInInstant(credential) async {
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      FirebaseAuth.instance.currentUser().then((val) async {
        setState(() {
          m = 2;
        });
        await checkifUserExistsInstant(val.uid);
        if (!userCheck) {
          setState(() {
            m = 0;
            instantVerified = 1;
          });
          Timer(Duration(seconds: 3), () {
            createUserFirstTime(val.uid);
          });
        } else {
          setState(() {
            m = 0;
            instantVerified = 1;
          });
          Timer(Duration(seconds: 3), () {
            userExistSavePrefs(val.uid);
          });
        }
      });
    }).catchError((e) {});
  }

  signIn() async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      FirebaseAuth.instance.currentUser().then((val) async {
        await checkifUserExists(val.uid);
        if (!userCheck) {
          createUserFirstTime(val.uid);
        } else {
          userExistSavePrefs(val.uid);
        }
      });
    }).catchError((e) => print(e));
  }

  otpField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Center(
        child: PinCodeTextField(
          length: 6,
          obsecureText: false,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            borderRadius: BorderRadius.circular(5),
            inactiveColor: kolor("6485FF"),
            shape: PinCodeFieldShape.box,
          ),
          autoFocus: false,
          onChanged: (val) {
            this.smsCode = val;
          },
        ),
      ),
    );
  }

  text2() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Text(
        "Please enter OTP sent to your Phone, meanwhile we will try to auto-verify!",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: 'varela',
          fontSize: 17,
          color: Colors.black.withOpacity(0.4),
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  text1() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50),
      child: Text(
        "Please enter your Phone Number to Sign Up & Sign In",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: 'varela',
          fontSize: 17,
          color: Colors.black.withOpacity(0.4),
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  texthead1() {
    return Center(
      child: Text(
        "Ghar se Ghar Tak!",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: 'varela',
          fontSize: 30,
          color: Colors.black.withOpacity(0.7),
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  texthead2() {
    return Center(
      child: Text(
        "Veify Phone Number!",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          fontFamily: 'varela',
          fontSize: 30,
          color: Colors.black.withOpacity(0.7),
        ),
        softWrap: true,
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    barkolor();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: <Widget>[
                Center(
                  child: Container(
                    margin: EdgeInsets.only(
                        top: 30, left: 30, right: 30, bottom: 20),
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Image.asset('assets/images/food_delivery.png'),
                  ),
                ),
                SizedBox(height: 20),
                animatedFields(texthead1(), texthead2()),
                SizedBox(height: 20),
                animatedFields(text1(), text2()),
                SizedBox(height: 10),
                animatedFields(phoneNumberField(), otpField()),
                animatedFields(getIn(context), verify()),
              ],
            ),
            x == 0 ? linearProgress() : Text(""),
            instantVerified == 1
                ? Container(
                    color: Colors.black.withOpacity(0.2),
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.black12,
                              offset: Offset(0, 1),
                              spreadRadius: 3,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              EvaIcons.doneAll,
                              size: 50,
                              color: Colors.green,
                            ),
                            Text(
                              "Verified!",
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'varela',
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Text(""),
            m == 2 ? linearProgress() : Text(""),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
