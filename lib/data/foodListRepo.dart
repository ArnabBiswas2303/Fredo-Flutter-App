import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_ref.dart';
import '../models/foodItem.dart';

class FoodListRepo {
  final List<FoodItem> _foodList;

  FoodListRepo(this._foodList);

  Future<List<FoodItem>> fetchFood() async {
    return Future.delayed(Duration(seconds: 1), () async {
      List<FoodItem> productsList = [];
      QuerySnapshot products =
          await productsRef.where('instock', isEqualTo: true).getDocuments();

      products.documents.forEach((x) {
        List<int> ratings = List.from(x.data['foodRating']);
        productsList.add(FoodItem(
          date: (x.data["foodDateTime"] as Timestamp).toDate(),
          fId: x.data['foodId'],
          fName: x.data['foodName'],
          pId: x.data['producerId'],
          pName: x.data['producerName'],
          price: x.data['foodPrice'] is String
              ? int.parse(x.data['foodPrice'])
              : x.data['foodPrice'],
          fImg: x.data['foodImage'],
          fDes: x.data['foodDesc'],
          rating: ratings,
          category: x.data['category'],
        ));
      });
      return productsList;
    });
  }

  List<FoodItem> sortAscending() {
    _foodList.sort((x, y) {
      return (x.price.compareTo(y.price));
    });
    return [..._foodList];
  }

  List<FoodItem> sortDescending() {
    _foodList.sort((x, y) {
      return (y.price.compareTo(x.price));
    });
    return [..._foodList];
  }

  void foodList(List<FoodItem> f) {
    f.forEach((item) {
      _foodList.add(item);
    });
  }
}
