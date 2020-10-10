// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:consumer/firebase_ref.dart';
// import 'package:consumer/screens/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utils/utils.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerGeneral.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Profile extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Profile> {
  TextEditingController tcName, tcGender, tcEmail;
  ProgressDialog pr;
  @override
  void initState() {
    super.initState();
    tcName = TextEditingController();
    tcEmail = TextEditingController();
    tcGender = TextEditingController();
  }

  updateButton() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.white),
      child: FlatButton(
        padding: EdgeInsets.all(16),
        color: Colors.red.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          try {
            pr.show();
            await consumerRef
                .document(BlocProvider.of<ConsumerBloc>(context).consumer.cId)
                .updateData(
              {
                'cName': tcName.text,
                'cGender': tcGender.text,
                'cEmail': tcEmail.text,
              },
            );
            pr.hide();
            Navigator.of(context).pop();
          } catch (e) {
            print(e);
          }
        },
        child: Center(
          child: Text(
            "Update",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
          // onChanged: (value) {
          //   controllerX.text = value;
          // },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context);
    String cId = BlocProvider.of<ConsumerBloc>(context).consumer.cId;
    return Scaffold(
      backgroundColor: kolor("#e1e2e1"),
      appBar: headerGeneral("Profile"),
      drawer: drawerNav(context),
      body: FutureBuilder(
        future: consumerRef.document(cId).get(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) return loading(ctx);
          var emailHint = snapshot.data['cEmail'];
          var nameHint = snapshot.data['cName'];
          var genderHint = snapshot.data['cGender'];
          return ListView(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 16, right: 16),
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                BlocProvider.of<ConsumerBloc>(context).consumer.cName,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    color: thatBlueColor(),
                    fontSize: 25,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              fieldRows(nameHint, tcName, "Name"),
              SizedBox(height: 16),
              fieldRows(genderHint, tcGender, "Gender"),
              SizedBox(height: 16),
              fieldRows(emailHint, tcEmail, "Email"),
              SizedBox(height: 36),
              updateButton(),
            ],
          );
        },
      ),
    );
  }
}
