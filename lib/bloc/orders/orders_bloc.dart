import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import '../../data/ordersRepo.dart';
import '../../models/order.dart';
import '../../firebase_ref.dart';
import 'package:uuid/uuid.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepo ordersRepo;
  OrdersBloc(this.ordersRepo);

  @override
  OrdersState get initialState => OrdersInitial();

  @override
  Stream<OrdersState> mapEventToState(
    OrdersEvent event,
  ) async* {
    if (event is IncreseFoodQuantity) {
      yield OrderIncreased(ordersRepo.increaseQuantity(event.id));
    } else if (event is DecreaseFoodQuantity) {
      yield OrderDecreased(ordersRepo.decreaseQuantity(event.id));
    } else if (event is CheckoutCart) {
      // yield OrderLoading();
      // await ordersRepo.checkOut();
      // yield OrderSent();
      List<Map<String, Object>> notAllOrders = [];
      Map<String, Order> currentCart = ordersRepo.getCartItem;
      String pId = "";
      String pName = "";
      currentCart.forEach((k, v) {
        if (pId == "") pId = v.foodItem.pId;
        if (pName == "") pName = v.foodItem.pName;
        notAllOrders.add({
          "quantity": v.quantity,
          "foodName": v.foodItem.fName,
          "foodId": v.foodItem.fId,
          "price": v.foodItem.price,
          "imageURL": v.foodItem.fImg,
        });
      });
      String orderId = Uuid().v4();
      await orderRef.document(orderId).setData({
        "consumerId": event.cId,
        "consumerName": event.cName,
        "producerId": pId,
        "producerName": pName,
        "isDone": false,
        "orderId": orderId,
        "orderDetails": notAllOrders,
        "date": DateTime.now(),
        "total": event.total,
      });
      ordersRepo.clearCart();
      yield OrdersInitial();
    } else if (event is GetOrderList) {
      yield OrderList(ordersRepo.getCartItem);
    } else if (event is RemoveFromCart) {
      yield OrderRemoved(ordersRepo.removeFromCart(event.id));
    }
  }
}
