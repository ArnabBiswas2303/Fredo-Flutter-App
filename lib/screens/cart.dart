import 'package:cached_network_image/cached_network_image.dart';
import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/orders/orders_bloc.dart';
import '../models/order.dart';
import '../screens/payment.dart';
import '../utils/utils.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerGeneral.dart';

class Cart extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Cart> {
  itemCard(String key, Order order) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) {
            return AlertDialog(
              title: Text('Are You Sure?'),
              content: Text('Do you want to remove the item from the cart?'),
              actions: <Widget>[
                FlatButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(ctx).pop(true);
                  },
                )
              ],
            );
          },
        );
      },
      onDismissed: (dismissed) =>
          BlocProvider.of<OrdersBloc>(context).add(RemoveFromCart(key)),
      key: Key(key),
      background: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(
            EvaIcons.trash,
            color: Colors.white,
          ),
        ),
      ),
      child: Container(
        key: Key(key),
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: order.foodItem.fImg,
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.18,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    order.foodItem.fName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black.withOpacity(0.05)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          GestureDetector(
                              child: Icon(
                                EvaIcons.arrowCircleDownOutline,
                                size: 26,
                                color: Colors.red,
                              ),
                              onTap: () {
                                BlocProvider.of<OrdersBloc>(context)
                                    .add(DecreaseFoodQuantity(key));
                              }),
                          SizedBox(width: 10),
                          Text(
                            "x ${order.quantity}",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            child: Icon(
                              EvaIcons.arrowCircleUpOutline,
                              size: 26,
                              color: Colors.green,
                            ),
                            onTap: () {
                              BlocProvider.of<OrdersBloc>(context)
                                  .add(IncreseFoodQuantity(key));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 30),
                    Text(
                      "₹ ${order.foodItem.price * order.quantity}",
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<OrdersBloc>(context).add(GetOrderList());
    return Scaffold(
      backgroundColor: kolor("e1e2e1"),
      appBar: headerGeneral("Cart"),
      drawer: drawerNav(context),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state is OrderList)
            return buildStack(context, state.orderList);
          else if (state is OrderIncreased)
            return buildStack(context, state.orderList);
          else if (state is OrderDecreased)
            return buildStack(context, state.orderList);
          else if (state is OrderRemoved) {
            return buildStack(context, state.orderList);
          } else if (state is OrdersInitial) {
            return buildCenterText(context, "Nothing To Show!");
          }
          return null;
        },
      ),
    );
  }

  Widget buildStack(BuildContext context, Map<String, Order> _cartList) {
    if (_cartList.isEmpty) return buildCenterText(context, "Nothing To Show!");
    var _cart = [];
    double total = 0;
    _cartList.forEach(
      (k, v) {
        total += v.quantity * v.foodItem.price;
        _cart.add(itemCard(k, v));
      },
    );
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.only(top: 10, bottom: 300, left: 10, right: 10),
          children: <Widget>[..._cart],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, -5),
                    blurRadius: 20,
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 10,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "TOTAL",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: thatBlueColor()),
                          softWrap: true,
                        ),
                        Text(
                          "\₹ $total",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: thatBlueColor()),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 10),
                    child: FlatButton(
                      padding: EdgeInsets.all(8),
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        String cId =
                            BlocProvider.of<ConsumerBloc>(context).consumer.cId;
                        String cName = BlocProvider.of<ConsumerBloc>(context)
                            .consumer
                            .cName;
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              BlocProvider.of<OrdersBloc>(context)
                                  .add(CheckoutCart(cId, cName, total));
                              return Payment(); // send payment data to put in firestore
                            },
                          ),
                        );
                      },
                      child: Center(
                        child: Text(
                          "Checkout",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}

Scaffold buildCenterText(BuildContext context, String text) {
  return Scaffold(
    backgroundColor: kolor("F0F1F0"),
    drawer: drawerNav(context),
    body: Center(
      child: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/flyingBurger.webp"),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10),
          child: Center(
            child: Text(
              "No Orders Yet!",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    ),
  );
}
