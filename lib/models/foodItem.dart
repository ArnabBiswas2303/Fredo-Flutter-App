import 'package:flutter/foundation.dart';

class FoodItem {
  final String fId;
  final String fName;
  final String fImg;
  final String fDes;
  final int price;
  final DateTime date;
  final String pName;
  final String pId;
  final String category;
  final List rating;

  FoodItem({
    @required this.fId,
    @required this.fName,
    @required this.price,
    @required this.date,
    @required this.pName,
    @required this.pId,
    @required this.fImg,
    @required this.fDes,
    @required this.rating,
    @required this.category,
  });
}
