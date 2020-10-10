import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../models/consumer.dart';

part 'consumer_event.dart';
part 'consumer_state.dart';

class ConsumerBloc extends Bloc<ConsumerEvent, ConsumerState> {
  final Consumer consumer;

  ConsumerBloc(this.consumer);
  @override
  ConsumerState get initialState => ConsumerInitial(consumer);

  @override
  Stream<ConsumerState> mapEventToState(
    ConsumerEvent event,
  ) async* {
    if (event is GetConsumerData) {
      yield ConsumerData(consumer);
    }
  }
}
