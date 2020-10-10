// import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/account.dart';
import '../screens/home.dart';
import '../screens/orders.dart';
import '../utils/utils.dart';
import '../bloc/consumer/consumer_bloc.dart';

navRowsText(x) {
  return ListTile(
    leading: Text(
      x,
      textAlign: TextAlign.center,
      softWrap: true,
      style: TextStyle(
          color: thatBlueColor(), fontSize: 18, fontWeight: FontWeight.w300),
    ),
  );
}

navRows(x, y, context) {
  StatefulWidget st;
  switch (y) {
    case "Home":
      st = Home();
      break;
    case "Orders":
      st = Orders();
      break;
    case "Account":
      st = Account();
      break;
  }
  return ListTile(
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return st;
          },
        ),
      );
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
          color: thatBlueColor(), fontSize: 18, fontWeight: FontWeight.w300),
    ),
  );
}

// App Drawer (Side)
drawerNav(BuildContext context) {
  final handler = BlocProvider.of<ConsumerBloc>(context);
  return SizedBox(
    child: Drawer(
      child: Container(
        color: kolor("#F0F1F0"),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 50),
                BlocBuilder<ConsumerBloc, ConsumerState>(
                  builder: (_, state) {
                    if (state is ConsumerInitial) return textName(state);
                    return somethingWentWrong();
                  },
                ),
                SizedBox(height: 20),
                // Following Rows Display Text and Column
                navRows(EvaIcons.homeOutline, "Home", context),
                navRows(EvaIcons.bellOutline, "Orders", context),
                navRows(EvaIcons.personOutline, "Account", context),
              ],
            ),
            Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Divider(thickness: 1),
                ),
                GestureDetector(
                  child: navRowsText("CONTACT US"),
                  onTap: () {},
                ),
              ],
            )
          ],
        ),
      ),
    ),
    width: MediaQuery.of(context).size.width * 0.65,
    // using a sizedbox to limit width of Drawer
  );
}

Text textName(final ConsumerInitial state) {
  return Text(
    state.consumer.cName,
    textAlign: TextAlign.center,
    softWrap: true,
    style: TextStyle(
        color: thatBlueColor(), fontSize: 25, fontWeight: FontWeight.w500),
  );
}

CircleAvatar circleAvatar(final ConsumerInitial state) {
  return CircleAvatar(
    radius: 55,
  );
}

Container somethingWentWrong() {
  return Container(
    child: Center(
      child: Text("Something Went Wrong!"),
    ),
  );
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
