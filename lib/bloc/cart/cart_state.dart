part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {
  final int cartCount;

  CartInitial(this.cartCount);
}

class OrderAdded extends CartState {
  final int cartCount;

  OrderAdded(this.cartCount);
}

class OrderNotAdded extends CartState {
  final int cartCount;

  OrderNotAdded(this.cartCount);
}
