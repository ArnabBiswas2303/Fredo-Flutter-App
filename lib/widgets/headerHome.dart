import 'package:badges/badges.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/cart/cart_bloc.dart';
import '../screens/cart.dart';
import '../screens/search.dart';
import '../utils/utils.dart';

homeAppBar(BuildContext context) {
  return AppBar(
    brightness: Brightness.light,
    elevation: 0,
    titleSpacing: 0,
    // centerTitle: true,
    iconTheme: new IconThemeData(
      color:
          thatBlueColor(), // using our primary color, can be found in utils class
    ),
    backgroundColor: Colors.white,
    title: Text(
      "Ghar se Ghar Tak",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: thatBlueColor(),
      ),
    ),
    actions: <Widget>[
      // Search Icon Navigates to Search Page
      IconButton(
        icon: Icon(
          EvaIcons.searchOutline,
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Search();
          }));
        },
      ),
      BlocBuilder<CartBloc, CartState>(
        builder: (_, state) {
          if (state is CartInitial)
            return buildCartButton(state.cartCount, context);
          else if (state is OrderAdded)
            return buildCartButton(state.cartCount, context);
          else if (state is OrderNotAdded)
            return buildCartButton(state.cartCount, context);
          return null;
        },
      ),
    ],
  );
}

Container buildCartButton(int cartCount, BuildContext context) {
  BlocProvider.of<CartBloc>(context).add(GetInitial());
  return Container(
    margin: EdgeInsets.only(top: 4),
    child: Badge(
      position: BadgePosition.topRight(top: 0, right: 4),
      badgeColor: Colors.blue,
      borderRadius: 30,
      animationType: BadgeAnimationType.fade,
      badgeContent: Text(
        cartCount.toString(),
        style: TextStyle(color: Colors.white),
      ),
      child: IconButton(
        icon: Icon(EvaIcons.shoppingCartOutline),
        color: Colors.black,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Cart();
          }));
        },
        iconSize: 25,
      ),
    ),
  );
}
