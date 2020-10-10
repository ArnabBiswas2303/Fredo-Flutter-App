import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:consumer/firebase_ref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../utils/utils.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerGeneral.dart';

class Address extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Address> {
  ProgressDialog pr;
  TextEditingController fullAddress, state, pincodeC, city;
  @override
  void initState() {
    super.initState();
    fullAddress = TextEditingController();
    state = TextEditingController();
    pincodeC = TextEditingController();
    city = TextEditingController();
  }

  bool showDialogVal = false;

  nameRows(x, controllerX) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: TextField(
          style: TextStyle(fontSize: 16),
          controller: controllerX,
          cursorColor: Colors.black,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.go,
          decoration: InputDecoration(
            hintText: x,
            hintStyle: TextStyle(fontSize: 16),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
          ),
        ),
      ),
    );
  }

  // deleteAddress() {
  //   showDialog(
  //       context: context,
  //       builder: (_) => AlertDialog(
  //             actions: <Widget>[
  //               FlatButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text("NO")),
  //               FlatButton(
  //                   onPressed: () {
  //                     Navigator.of(context).pop();
  //                   },
  //                   child: Text("YES")),
  //             ],
  //             title: Text("Delete this Address?"),
  //             elevation: 0,
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10)),
  //           ),
  //       barrierDismissible: false);
  // }

  dialogView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.black.withOpacity(0.6),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      nameRows("Full Address", fullAddress),
                      SizedBox(height: 10),
                      nameRows("City", city),
                      SizedBox(height: 10),
                      nameRows("State", state),
                      SizedBox(height: 10),
                      nameRows("Pincode", pincodeC),
                      SizedBox(height: 5),
                      submitButton("Cancel", Colors.red),
                      submitButton("Submit", Colors.green),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  submitButton(String name, MaterialColor color) {
    return FlatButton(
      padding: EdgeInsets.all(5),
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      onPressed: () async {
        try {
          if (name.compareTo("Submit") == 0) {
            var doc = BlocProvider.of<ConsumerBloc>(context).consumer.cId;
            pr.show();
            await consumerRef.document(doc).updateData({
              'cAddress': {
                'fullAddress': fullAddress.text,
                'city': city.text,
                'state': state.text,
                'pincode': int.parse(pincodeC.text),
              }
            });
          }
        } catch (e) {
          print(e);
        } finally {
          pr.hide();
          setState(() {
            showDialogVal = false;
          });
        }
      },
      child: Center(
        child: Text(
          name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  // addressCard(x, y) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 10),
  //     padding: EdgeInsets.all(20),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           x,
  //           textAlign: TextAlign.left,
  //           style: TextStyle(
  //               fontSize: 21,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.black87),
  //         ),
  //         SizedBox(height: 5),
  //         Divider(
  //           height: 10,
  //           thickness: 2,
  //           color: kolor("F0F1F0"),
  //         ),
  //         SizedBox(height: 5),
  //         Text(
  //           y,
  //           textAlign: TextAlign.left,
  //           style: TextStyle(fontSize: 15),
  //         ),
  //         SizedBox(height: 10),
  //         Row(
  //           mainAxisSize: MainAxisSize.min,
  //           children: <Widget>[
  //             FlatButton(
  //               padding: EdgeInsets.all(5),
  //               color: Colors.red.withOpacity(0.1),
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(50)),
  //               onPressed: () {
  //                 deleteAddress();
  //               },
  //               child: Center(
  //                 child: Text(
  //                   "Delete",
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.red,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    return Scaffold(
      backgroundColor: kolor("#E1E2E1"),
      appBar: headerGeneral("Address"),
      drawer: drawerNav(context),
      // body: Stack(
      //   children: <Widget>[
      //     ListView(
      //       padding: EdgeInsets.only(
      //         top: 10,
      //         bottom: 100,
      //         left: 10,
      //         right: 10,
      //       ),
      //       children: <Widget>[
      //         addressCard(addresses[0][0], addresses[0][1]),
      //         addressCard(addresses[1][0], addresses[1][1]),
      //       ],
      //     ),
      //     loader ? loading(context) : Text(""),
      //     showDialogVal ? dialogView(context) : Text(""),
      //   ],
      // ),
      body: StreamBuilder(
        stream: consumerRef
            .document(BlocProvider.of<ConsumerBloc>(context).consumer.cId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return loading(context);
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      addressField(
                        context,
                        "Full Address",
                        (snapshot.data['cAddress'])['fullAddress'],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: <Widget>[
                          stateCity(
                            context,
                            "State",
                            (snapshot.data['cAddress'])['state'],
                            Colors.lime,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          stateCity(
                            context,
                            "City",
                            (snapshot.data['cAddress'])['city'],
                            Colors.cyan,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      pincode(
                        Colors.orange,
                        context,
                        "Pincode",
                        (snapshot.data['cAddress'])['pincode'].toString(),
                      ),
                    ],
                  ),
                ),
              ),
              showDialogVal ? dialogView(context) : Text(""),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {},
        child: IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.green,
            size: 30,
          ),
          onPressed: () async {
            setState(() {
              showDialogVal = true;
              // loader = false;
            });
          },
        ),
      ),
    );
  }
}

Container loading(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 3,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}

fieldRows(x, controllerX, label) {
  return Container(
    padding: EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Center(
      child: TextField(
        style: TextStyle(fontSize: 20),
        controller: controllerX,
        cursorColor: Colors.black,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.go,
        decoration: InputDecoration(
          labelText: label,
          hintText: x,
          hasFloatingPlaceholder: true,
          hintStyle: TextStyle(fontSize: 20),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 15),
        ),
      ),
    ),
  );
}

Center addressField(BuildContext context, String label, String innerData) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              label,
              style: TextStyle(fontSize: 29, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            innerData,
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Flexible stateCity(
    BuildContext context, String label, String innerData, Color colors) {
  return Flexible(
    child: pincode(colors, context, label, innerData),
  );
}

Center pincode(
    Color colors, BuildContext context, String label, String innerData) {
  return Center(
    child: Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      width: MediaQuery.of(context).size.width * 0.80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            innerData,
            style: TextStyle(fontSize: 17),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
