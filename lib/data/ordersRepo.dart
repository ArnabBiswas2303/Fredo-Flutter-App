import '../models/foodItem.dart';
import '../models/order.dart';

class OrdersRepo {
  Map<String, Order> _cart = {};
  String currentProducer;

  // String getProducerId(){
  //   if(_cart.isNotEmpty){
  //     _cart.
  //   }
  //   return "";
  // }

  int addToCart(FoodItem f) {
    var o = Order(foodItem: f, quantity: 1);
    if (_cart.isNotEmpty && (currentProducer.compareTo(f.pId)) == 0) {
      _cart[f.fId] = o;
    }
    if (_cart.isEmpty) {
      _cart[f.fId] = o;
      currentProducer = f.pId;
    }
    return _cart.length;
  }

  int get getCartCount {
    return _cart.length;
  }

  Map<String, Order> get getCartItem {
    return {..._cart};
  }

  Map<String, Order> removeFromCart(String id) {
    _cart.remove(id);
    return {..._cart};
  }

  void clearCart() {
    _cart = {};
  }

  Map<String, Order> increaseQuantity(String id) {
    _cart[id].quantity += 1;
    return {..._cart};
  }

  Map<String, Order> decreaseQuantity(String id) {
    if (_cart[id].quantity > 1) _cart[id].quantity -= 1;
    return {..._cart};
  }

  Future<bool> checkOut() {
    return Future.delayed(
      Duration(seconds: 5),
      () {
        // final random = Random();
        // if (random.nextBool()) {
        //   throw NetworkError();
        // }
        return true;
      },
    );
  }
}

class NetworkError extends Error {}
