part of 'food_bloc.dart';

@immutable
abstract class FoodEvent {}

class GetFood extends FoodEvent {}

class SortAscending extends FoodEvent {}

class SortDescending extends FoodEvent {}
