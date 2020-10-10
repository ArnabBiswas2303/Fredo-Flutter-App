import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:consumer/firebase_ref.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../bloc/cart/cart_bloc.dart';
import '../models/foodItem.dart';
import '../screens/cart.dart';

class ProductDetail extends StatefulWidget {
  // final String name, imageUrl, price, rating, producer;
  // ProductDetail(
  //     {this.name, this.imageUrl, this.price, this.producer, this.rating});
  final FoodItem foodItem;
  const ProductDetail({Key key, this.foodItem}) : super(key: key);
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  int rating = 1;
  @override
  Widget build(BuildContext context) {
    double stars = 0;
    if (widget.foodItem.rating.isNotEmpty) {
      widget.foodItem.rating.forEach((r) {
        stars += r;
      });
      stars = stars / widget.foodItem.rating.length;
    }
    BlocProvider.of<CartBloc>(context).add(GetInitial());
    backAndCart() {
      return Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(EvaIcons.arrowBackOutline),
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              iconSize: 30,
            ),
            BlocConsumer<CartBloc, CartState>(
              listener: (_, state) {
                if (state is OrderNotAdded) {
                  Scaffold.of(_).showSnackBar(SnackBar(
                    duration: Duration(milliseconds: 800),
                    content: Text("You can only buy from one chef."),
                  ));
                }
              },
              builder: (_, state) {
                if (state is CartInitial) {
                  return buildCartButton(state.cartCount, context);
                } else if (state is OrderAdded) {
                  return buildCartButton(state.cartCount, context);
                } else if (state is OrderNotAdded) {
                  return buildCartButton(state.cartCount, context);
                }
                return null;
              },
            )
          ],
        ),
      );
    }

    namePrice(name, price) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              name.length > 25 ? name.substring(0, 20) + "...." : name,
              softWrap: true,
              style: TextStyle(
                fontSize: 28,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "₹ $price",
              softWrap: true,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Builder(builder: (context) {
          return Stack(
            children: <Widget>[
              ListView(
                padding: EdgeInsets.only(bottom: 100),
                children: <Widget>[
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.cover,
                    imageUrl: widget.foodItem.fImg,
                  ),
                  SizedBox(height: 20),
                  namePrice(widget.foodItem.fName, widget.foodItem.price),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              widget.foodItem.pName,
                              textAlign: TextAlign.left,
                              style: TextStyle(fontSize: 17),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  "${stars.toString().length < 4 ? stars : stars.toString().substring(0, 4)}",
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(width: 10),
                                Icon(
                                  EvaIcons.star,
                                  color: Colors.amber,
                                )
                              ],
                            )
                          ],
                        ),
                        Text("Categories: ${widget.foodItem.category}"),
                        SizedBox(height: 20),
                        Text(
                          widget.foodItem.fDes,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 17, fontStyle: FontStyle.italic),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  backAndCart(),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Expanded(
                          child: FlatButton(
                            padding: EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            onPressed: () {
                              var cart = BlocProvider.of<CartBloc>(context)
                                  .ordersRepo
                                  .getCartItem;
                              if (cart[widget.foodItem.fId] == null) {
                                BlocProvider.of<CartBloc>(context)
                                    .add(AddFoodToCart(widget.foodItem));
                              } else {
                                Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(milliseconds: 800),
                                    content: Text("Already added to cart."),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Add to Cart",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              _settingModalBottomSheet(context);
                            },
                            child: Text(
                              "Rate Product",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          );
        }),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              padding: EdgeInsets.all(20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "Rating : $rating",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    divisions: 4,
                    value: rating.toDouble(),
                    onChanged: (val) {
                      setState(() {
                        rating = val.toInt();
                      });
                    },
                    min: 1,
                    max: 5,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FlatButton(
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ),
                          onPressed: () async {
                            Fluttertoast.showToast(msg: "Rating Submitted!");
                            final document = await productsRef
                                .document("${widget.foodItem.fId}")
                                .get();
                            List<int> newRating =
                                List.from(document.data['foodRating']);
                            newRating.add(rating);
                            await document.reference
                                .updateData({'foodRating': newRating});
                            Navigator.of(bc).pop();
                          },
                          child: Text(
                            "Submit Rating",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }
}

Container buildCartButton(int cartCount, BuildContext context) {
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
        color: Colors.white,
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
