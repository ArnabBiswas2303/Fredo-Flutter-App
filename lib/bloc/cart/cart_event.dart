part of 'cart_bloc.dart';

@immutable
abstract class CartEvent {}

class GetInitial extends CartEvent {}

class AddFoodToCart extends CartEvent {
  final FoodItem f;

  AddFoodToCart(this.f);
}
