import 'package:flutter/foundation.dart';
import 'address.dart';

class Consumer {
  String cId;
  String cName;
  String cGender;
  String cEmail;
  String cBirthDay;
  Address cAddress;

  Consumer({
    @required this.cId,
    @required this.cName,
    @required this.cGender,
    @required this.cEmail,
    @required this.cBirthDay,
    @required this.cAddress,
  });
}
