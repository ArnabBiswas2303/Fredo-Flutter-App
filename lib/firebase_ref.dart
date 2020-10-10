import 'package:cloud_firestore/cloud_firestore.dart';

final consumerRef = Firestore.instance.collection('consumerProfiles');
final productsRef = Firestore.instance.collection('productItems');
final orderRef = Firestore.instance.collection('orders');
