part of 'consumer_bloc.dart';

@immutable
abstract class ConsumerState {}

class ConsumerInitial extends ConsumerState {
  final Consumer consumer;

  ConsumerInitial(this.consumer);
}

class ConsumerData extends ConsumerState {
  final Consumer consumer;

  ConsumerData(this.consumer);
}
