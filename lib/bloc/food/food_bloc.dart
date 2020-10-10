import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/foodItem.dart';
import '../../data/foodListRepo.dart';

part 'food_event.dart';
part 'food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  final FoodListRepo foodListRepo;
  FoodBloc(this.foodListRepo);

  @override
  FoodState get initialState => FoodInitial();

  @override
  Stream<FoodState> mapEventToState(
    FoodEvent event,
  ) async* {
    if (event is GetFood) {
      try {
        yield FoodLoading();
        final foodList = await foodListRepo.fetchFood();
        foodListRepo.foodList(foodList);
        yield FoodLoaded(foodList);
      } catch (e) {
        print(e);
        yield FoodLoadingError("Check Your Internet!");
      }
    } else if (event is SortAscending) {
      yield FoodListAscending(foodListRepo.sortAscending());
    } else if (event is SortDescending) {
      yield FoodListDescending(foodListRepo.sortDescending());
    }
  }
}
