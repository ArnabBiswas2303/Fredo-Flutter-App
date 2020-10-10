import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumer/firebase_ref.dart';
import 'package:consumer/models/foodItem.dart';
import 'package:consumer/screens/productDetail.dart';
import 'package:consumer/utils/utils.dart';
import 'package:consumer/widgets/headerGeneral.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CategoryResults extends StatefulWidget {
  final String searchKey;
  CategoryResults(this.searchKey);

  @override
  _CategoryResultsState createState() => _CategoryResultsState();
}

class _CategoryResultsState extends State<CategoryResults> {
  mealCard(FoodItem foodItem) {
    double stars = 0;
    if (foodItem.rating.isNotEmpty) {
      foodItem.rating.forEach((r) {
        stars += r;
      });
      stars = stars / foodItem.rating.length;
    }
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ProductDetail(
              foodItem: foodItem,
            );
          }));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        isThreeLine: true,
        leading: CachedNetworkImage(
          imageUrl: foodItem.fImg,
          fit: BoxFit.cover,
        ),
        title: Text(foodItem.fName, style: TextStyle(fontSize: 17)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(foodItem.pName),
            Row(
              children: <Widget>[
                Text("$stars"),
                SizedBox(width: 10),
                Icon(
                  EvaIcons.star,
                  color: Colors.amber,
                )
              ],
            )
          ],
        ),
        trailing: Text(
          "₹ ${foodItem.price}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kolor("e1e2e1"),
      appBar: headerGeneral("Category Results"),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(bottom: 100, left: 10, right: 10, top: 10),
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Text(
                  "Category : \" ${widget.searchKey} \"",
                  textAlign: TextAlign.center,
                  softWrap: true,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Divider(
                indent: 10,
                endIndent: 10,
                color: Colors.black38,
                thickness: 1,
              ),
              StreamBuilder(
                stream: productsRef
                    .where("category", isEqualTo: widget.searchKey)
                    .snapshots(),
                builder: (context, snapshot) {
                  List<Container> tempList = [];
                  if (!snapshot.hasData) {
                    print("Sdadas sd sa - - -- - - -- ${snapshot.data}");
                    return Container(
                      child: SpinKitRing(
                        color: Colors.black,
                        lineWidth: 2,
                        size: 30,
                      ),
                    );
                  } else {
                    snapshot.data.documents.forEach((x) {
                      List<int> ratings = List.from(x['foodRating']);
                      FoodItem foodItem = FoodItem(
                        date: (x["foodDateTime"] as Timestamp).toDate(),
                        fId: x['foodID'],
                        fName: x['foodName'],
                        pId: x['producerId'],
                        pName: x['producerName'],
                        price: 170,
                        fImg: x['foodImage'],
                        fDes: x['foodDesc'],
                        rating: ratings,
                        category: x['category'],
                      );
                      tempList.add(mealCard(foodItem));
                    });
                  }
                  if (tempList.isEmpty) {
                    return Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Icon(
                          EvaIcons.alertTriangleOutline,
                          color: Colors.amber,
                        ),
                        title: Text(
                          "Did not find any item related to Category : ${widget.searchKey}",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    );
                  } else
                    return Column(
                      children: tempList,
                    );
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
