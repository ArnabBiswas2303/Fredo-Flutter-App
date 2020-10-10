import '../models/consumer.dart';

class ConsumerRepo {
  final Consumer consumer;
  ConsumerRepo(this.consumer);

  Consumer getCustomerData() {
    return consumer;
  }
}
