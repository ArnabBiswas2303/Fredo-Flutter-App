import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:consumer/models/ongoingprevious.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../firebase_ref.dart';
import '../screens/order_status.dart';
import '../utils/utils.dart';
import '../widgets/column_builder.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerGeneral.dart';

class Orders extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Orders> {
  orderCard(OngoingPrevious onpre) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return OrderStatus(
              date: onpre.date,
              key: Key(onpre.orderId),
              orderDetails: onpre.orderDetails,
              orderId: onpre.orderId,
              total: onpre.total.toString(),
              producerName: onpre.producerName,
            );
          }));
        },
        dense: true,
        contentPadding: EdgeInsets.all(0),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text("#${onpre.productsNumber}"),
        ),
        title: Text(
          onpre.producerName,
          style: TextStyle(fontSize: 15),
        ),
        subtitle: Text(
          onpre.date.toString(),
          style: TextStyle(fontSize: 12),
        ),
        trailing: Text(
          "\₹ " + onpre.total.toString(),
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kolor("#e1e2e1"),
        appBar: headerGeneral("Orders"),
        drawer: drawerNav(context),
        body: StreamBuilder(
          stream: orderRef
              .where('consumerId',
                  isEqualTo:
                      BlocProvider.of<ConsumerBloc>(context).consumer.cId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return loading(context);
            List<OngoingPrevious> ongoing = [];
            List<OngoingPrevious> previous = [];
            snapshot.data.documents.forEach((x) {
              if (x.data['isDone']) {
                previous.add(
                  OngoingPrevious(
                    date: DateFormat.yMMMMEEEEd()
                        .format((x.data['date'] as Timestamp).toDate()),
                    orderId: x.data['orderId'],
                    total: x.data['total'],
                    productsNumber: x.data['orderDetails'].length,
                    orderDetails: x.data['orderDetails'],
                    producerName: x.data['producerName'],
                    dateTime: (x.data['date'] as Timestamp).toDate(),
                  ),
                );
              } else {
                ongoing.add(
                  OngoingPrevious(
                    date: DateFormat.yMMMMEEEEd()
                        .format((x.data['date'] as Timestamp).toDate()),
                    orderId: x.data['orderId'],
                    total: x.data['total'],
                    productsNumber: x.data['orderDetails'].length,
                    orderDetails: x.data['orderDetails'],
                    producerName: x.data['producerName'],
                    dateTime: (x.data['date'] as Timestamp).toDate(),
                  ),
                );
              }
              previous.sort((a, b) {
                DateTime x = a.dateTime;
                DateTime y = b.dateTime;
                return y.compareTo(x);
              });
              ongoing.sort((a, b) {
                DateTime x = a.dateTime;
                DateTime y = b.dateTime;
                return y.compareTo(x);
              });
            });
            return ListView(
              padding:
                  EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 100),
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(
                    "Ongoing ",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.black38,
                  thickness: 1,
                ),
                ColumnBuilder(
                  itemBuilder: (context, index) {
                    return orderCard(ongoing[index]);
                  },
                  itemCount: ongoing.length,
                ),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Text(
                    "Previous",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.black38,
                  thickness: 1,
                ),
                ColumnBuilder(
                  itemBuilder: (context, index) {
                    return orderCard(previous[index]);
                  },
                  itemCount: previous.length,
                ),
              ],
            );
          },
        ));
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

Container nothingToShow() {
  return Container(
    child: Center(
      child: Text("Nothing To Show!"),
    ),
  );
}
