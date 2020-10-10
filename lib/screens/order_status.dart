import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import '../utils/utils.dart';
import '../widgets/column_builder.dart';
import '../widgets/headerGeneral.dart';

class OrderStatus extends StatefulWidget {
  final List<dynamic> orderDetails;
  final String orderId;
  final String date;
  final String total;
  final String producerName;

  const OrderStatus({
    Key key,
    this.orderDetails,
    this.orderId,
    this.date,
    this.total,
    this.producerName,
  }) : super(key: key);
  @override
  _OrderStatusState createState() => _OrderStatusState();
}

class _OrderStatusState extends State<OrderStatus> {
  mealCard(dynamic order) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        isThreeLine: true,
        leading: CachedNetworkImage(
          imageUrl: order['imageURL'],
          fit: BoxFit.cover,
        ),
        title: Text(order['foodName'], style: TextStyle(fontSize: 17)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(widget.producerName),
            Row(
              children: <Widget>[
                Text(order['quantity'].toString()),
                SizedBox(width: 10),
                Icon(
                  EvaIcons.shoppingBag,
                  color: Colors.amber,
                )
              ],
            )
          ],
        ),
        trailing: Text(
          "\₹ ${order['price']}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  // After Receiving the order ID the order details needs to be streamed
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: headerGeneral("Order Details"),
      backgroundColor: kolor("e1e2e1"),
      body: ListView(
        padding: EdgeInsets.only(top: 10, bottom: 100, left: 10, right: 10),
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            child: ListTile(
              title: Text(
                "Order ID : ${widget.orderId.substring(24)}",
                style: TextStyle(fontSize: 17),
              ),
              trailing: Text(
                "Total  : ₹ ${widget.total}",
                style: TextStyle(fontSize: 17),
              ),
              subtitle: Text(
                "Ordered at : ${widget.date}",
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Text(
              "Ordered Items",
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
          // it needs to  be streamed what were ordered through the order id
          ColumnBuilder(
              itemBuilder: (context, index) {
                return mealCard(widget.orderDetails[index]);
              },
              itemCount: widget.orderDetails.length)
        ],
      ),
    );
  }
}
