import 'package:flutter/material.dart';

import 'foodItem.dart';
import 'package:flutter/foundation.dart';

class Order {
  final FoodItem foodItem;
  int quantity;

  Order({
    @required this.foodItem,
    @required this.quantity,
  });
}
