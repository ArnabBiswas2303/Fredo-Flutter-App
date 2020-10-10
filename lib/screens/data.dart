import 'package:consumer/models/address.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../firebase_ref.dart';
import 'package:consumer/models/consumer.dart';

import 'package:flutter/material.dart';

import 'home.dart';
// import '../models/producerModel.dart';

class Data extends StatefulWidget {
  final Consumer consumer;
  final String doc;
  Data({Key key, this.consumer, this.doc}) : super(key: key);
  @override
  _DataState createState() => _DataState();
}

class Wrapper {
  String name;
  String gender;
  String email;
  String birthday;
  String address;
  String city;
  int pincode;
  String state;
  String accountName;
  String accountNumber;
  String bankName;
  String ifsc;

  Wrapper({
    this.name,
    this.gender,
    this.email,
    this.birthday,
    this.address,
    this.city,
    this.pincode,
    this.state,
    this.accountName,
    this.accountNumber,
    this.bankName,
    this.ifsc,
  });
}

class _DataState extends State<Data> {
  ProgressDialog pr;
  final formKey = GlobalKey<FormState>();
  Wrapper w = Wrapper();
  @override
  Widget build(BuildContext context) {
    ProgressDialog pr = new ProgressDialog(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffF0F1F0),
        body: Form(
          key: formKey,
          child: Center(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Just a few more things before we start!',
                      style: TextStyle(
                        fontSize: 45,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text(
                      'Personal Details',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  textInput(
                    context,
                    'Name',
                    w,
                    validateName,
                  ),
                  textInput(
                    context,
                    'Gender',
                    w,
                    validateGender,
                  ),
                  textInput(
                    context,
                    'Email',
                    w,
                    validateEmail,
                  ),
                  textInput(
                    context,
                    'Birthday',
                    w,
                    validateBirthday,
                  ),
                  ListTile(
                    title: Text(
                      'Address Details',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  textInput(
                    context,
                    'Address',
                    w,
                    validateAddress,
                  ),
                  textInput(
                    context,
                    'City',
                    w,
                    validateCity,
                  ),
                  textInput(
                    context,
                    'Pincode',
                    w,
                    validatePincode,
                  ),
                  textInput(
                    context,
                    'State',
                    w,
                    validateState,
                  ),
                  ListTile(
                    title: Text(
                      'Payment Details',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),
                    ),
                    subtitle:
                        Text('This is where you will recieve your payment'),
                  ),
                  textInput(
                    context,
                    'Account Name',
                    w,
                    genericValidator,
                  ),
                  textInput(context, 'Account Number', w, genericValidator),
                  textInput(context, 'Bank Name', w, genericValidator),
                  textInput(context, 'IFSC Code', w, genericValidator),
                  Container(
                    margin: EdgeInsets.all(15),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.pop(context);
                            },
                            child: Text(
                              'Back',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          child: GestureDetector(
                            onTap: () async {
                              if (formKey.currentState.validate()) {
                                formKey.currentState.save();
                                try {
                                  pr.show();
                                  await consumerRef
                                      .document("${widget.doc}")
                                      .updateData(
                                    {
                                      'isRegistered': true,
                                      'cName': w.name,
                                      'cGender': w.gender,
                                      'cEmail': w.email,
                                      'cBirthDay': w.birthday,
                                      'cAddress': {
                                        'fullAddress': w.address,
                                        'city': w.city,
                                        'state': w.state,
                                        'pincode': w.pincode
                                      },
                                    },
                                  );
                                  widget.consumer.cAddress = Address(
                                    city: w.city,
                                    fullAddress: w.address,
                                    pincode: w.pincode,
                                    state: w.state,
                                  );
                                  widget.consumer.cBirthDay = w.birthday;
                                  widget.consumer.cEmail = w.email;
                                  widget.consumer.cGender = w.gender;
                                  widget.consumer.cId = widget.doc;
                                  widget.consumer.cName = w.name;
                                  pr.hide();
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Home(
                                          cId: widget.doc,
                                        ); // send payment data to put in firestore
                                      },
                                    ),
                                  );
                                } catch (e) {
                                  somethingWentWrong();
                                }
                              }
                            },
                            child: Text(
                              'Next',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Container textInput(
      BuildContext context, String label, Wrapper ref, validator) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.015),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextFormField(
          validator: validator,
          style: TextStyle(fontSize: 20),
          cursorColor: Colors.black,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
            labelText: label,
            hasFloatingPlaceholder: true,
            hintStyle: TextStyle(fontSize: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
          ),
          onSaved: (value) {
            switch (label) {
              case "Name":
                {
                  ref.name = value;
                  break;
                }
              case "Gender":
                {
                  ref.gender = value;
                  break;
                }
              case "Email":
                {
                  ref.email = value;
                  break;
                }
              case "Birthday":
                {
                  ref.birthday = value;
                  break;
                }
              case "Address":
                {
                  ref.address = value;
                  break;
                }
              case "City":
                {
                  ref.city = value;
                  break;
                }
              case "Pincode":
                {
                  ref.pincode = int.parse(value);
                  break;
                }
              case "State":
                {
                  ref.state = value;
                  break;
                }
              case "Account Name":
                {
                  ref.accountName = value;
                  break;
                }
              case "Account Number":
                {
                  ref.accountNumber = value;
                  break;
                }
              case "Bank Name":
                {
                  ref.bankName = value;
                  break;
                }
              case "IFSC Code":
                {
                  ref.ifsc = value;
                  break;
                }
            }
          },
        ),
      ),
    );
  }
}

String validateName(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter Name";
  }
}

String validateGender(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter Gender";
  }
  if (value.toLowerCase().compareTo("male") != 0) {
    if (value.toLowerCase().compareTo("female") != 0) {
      return "Please Enter Valid Gender (Male/Female)";
    }
  }
}

String validateEmail(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter Email";
  }
  var x = new RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
  if (!value.contains(x)) {
    return "Please Enter A Valid Email!";
  }
}

String validateBirthday(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter Birthday";
  }
  var x = new RegExp(
      r'^([0-2][0-9]|(3)[0-1])(\/)(((0)[0-9])|((1)[0-2]))(\/)\d{4}$');
  if (!value.contains(x)) {
    return "Please Enter A Valid Birthday (dd,MM,yyyy)";
  }
}

String validatePincode(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter Pincode";
  }
  var x = new RegExp(r"^[1-9][0-9]{5}$");
  if (!value.contains(x)) {
    return "Please Enter A Valid Pincode";
  }
}

String validateAddress(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter Address";
  }
}

String validateState(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter State";
  }
}

String validateCity(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter City";
  }
}

String genericValidator(String value) {
  value = value.trim();
  if (value.isEmpty) {
    return "Please Enter A Value!";
  }
}
