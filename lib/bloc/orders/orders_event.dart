part of 'orders_bloc.dart';

@immutable
abstract class OrdersEvent {}

class GetOrderList extends OrdersEvent {}

class IncreseFoodQuantity extends OrdersEvent {
  final String id;

  IncreseFoodQuantity(this.id);
}

class DecreaseFoodQuantity extends OrdersEvent {
  final String id;

  DecreaseFoodQuantity(this.id);
}

class RemoveFromCart extends OrdersEvent {
  final String id;

  RemoveFromCart(this.id);
}

class CheckoutCart extends OrdersEvent {
  final String cId;
  final String cName;
  final double total;
  CheckoutCart(this.cId, this.cName, this.total);
}
