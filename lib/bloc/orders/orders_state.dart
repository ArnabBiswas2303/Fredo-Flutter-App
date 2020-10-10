part of 'orders_bloc.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class OrderList extends OrdersState {
  final Map<String, Order> orderList;

  OrderList(this.orderList);
}

class OrderIncreased extends OrdersState {
  final Map<String, Order> orderList;

  OrderIncreased(this.orderList);
}

class OrderDecreased extends OrdersState {
  final Map<String, Order> orderList;

  OrderDecreased(this.orderList);
}

class OrderRemoved extends OrdersState {
  final Map<String, Order> orderList;

  OrderRemoved(this.orderList);
}

class OrderLoading extends OrdersState {}

class OrderSent extends OrdersState {}
