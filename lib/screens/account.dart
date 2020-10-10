import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:consumer/screens/home.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/address.dart';
import '../screens/cart.dart';
import '../screens/orders.dart';
import '../screens/profile.dart';
import '../utils/utils.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerGeneral.dart';

import 'payment.dart';

class Account extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Account> {
  navRows(x, y, context) {
    StatefulWidget st;
    switch (y) {
      case "Orders":
        st = Orders();
        break;
      case "Cart":
        st = Cart();
        break;
      case "Profile Details":
        st = Profile();
        break;
      case "Address":
        st = Address();
        break;
      case "Payment":
        st = Home();
        break;
    }
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return st;
        }));
      },
      leading: Icon(
        x,
        color: thatBlueColor(),
        size: 25,
      ),
      title: Text(
        y,
        softWrap: true,
        style: TextStyle(
          color: thatBlueColor(),
          fontSize: 18,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kolor("#E1E2E1"),
      appBar: headerGeneral("Account"),
      drawer: drawerNav(context),
      body: ListView(
        padding: EdgeInsets.only(top: 20, bottom: 100),
        children: <Widget>[
          Column(
            children: <Widget>[
              Text(BlocProvider.of<ConsumerBloc>(context).consumer.cName,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      color: thatBlueColor(),
                      fontSize: 25,
                      fontWeight: FontWeight.w500))
            ],
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(left: 10, right: 10, top: 20),
            child: Column(
              children: <Widget>[
                navRows(EvaIcons.bellOutline, "Orders", context),
                navRows(EvaIcons.shoppingCartOutline, "Cart", context),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Column(
              children: <Widget>[
                navRows(EvaIcons.personAddOutline, "Profile Details", context),
                navRows(EvaIcons.pinOutline, "Address", context),
                navRows(EvaIcons.creditCardOutline, "Payment", context),
              ],
            ),
          )
        ],
      ),
    );
  }
}
