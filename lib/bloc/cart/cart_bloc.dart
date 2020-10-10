import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../data/ordersRepo.dart';

import '../../models/foodItem.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final OrdersRepo ordersRepo;

  CartBloc(this.ordersRepo);

  @override
  CartState get initialState => CartInitial(ordersRepo.getCartCount);

  @override
  Stream<CartState> mapEventToState(
    CartEvent event,
  ) async* {
    if (event is AddFoodToCart) {
      int previousCount = ordersRepo.getCartCount;
      int cartCount = ordersRepo.addToCart(event.f);
      if (previousCount == cartCount) {
        yield OrderNotAdded(cartCount);
      } else {
        yield OrderAdded(cartCount);
      }
    } else if (event is GetInitial) {
      int cartCount = ordersRepo.getCartCount;
      yield CartInitial(cartCount);
    }
  }
}
