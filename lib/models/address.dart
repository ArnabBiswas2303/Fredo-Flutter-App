import 'package:flutter/foundation.dart';

class Address {
  final String fullAddress;
  final String city;
  final String state;
  final int pincode;

  Address({
    @required this.fullAddress,
    @required this.city,
    @required this.state,
    @required this.pincode,
  });
}
