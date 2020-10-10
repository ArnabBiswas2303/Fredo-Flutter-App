part of 'food_bloc.dart';

@immutable
abstract class FoodState {}

class FoodInitial extends FoodState {}

class FoodLoading extends FoodState {}

class FoodLoaded extends FoodState {
  final List<FoodItem> foodList;
  FoodLoaded(this.foodList);
}

class FoodListAscending extends FoodState {
  final List<FoodItem> foodList;

  FoodListAscending(this.foodList);
}

class FoodListDescending extends FoodState {
  final List<FoodItem> foodList;

  FoodListDescending(this.foodList);
}

class FoodLoadingError extends FoodState {
  final String errMsg;

  FoodLoadingError(this.errMsg);
}
