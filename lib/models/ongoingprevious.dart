import 'package:flutter/foundation.dart';

class OngoingPrevious {
  @required
  final String orderId;
  @required
  final String producerName;
  @required
  final String date;
  @required
  final double total;
  @required
  final int productsNumber;
  @required
  final DateTime dateTime;
  @required
  final List<dynamic> orderDetails;

  OngoingPrevious({
    this.orderId,
    this.date,
    this.total,
    this.productsNumber,
    this.orderDetails,
    this.producerName,
    this.dateTime,
  });
}
