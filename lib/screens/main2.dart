import 'package:consumer/bloc/cart/cart_bloc.dart';
import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:consumer/bloc/food/food_bloc.dart';
import 'package:consumer/bloc/orders/orders_bloc.dart';
import 'package:consumer/data/foodListRepo.dart';
import 'package:consumer/data/ordersRepo.dart';
import 'package:consumer/firebase_ref.dart';
import 'package:consumer/models/address.dart';
import 'package:consumer/models/consumer.dart';
import 'package:consumer/screens/data.dart';
import 'package:consumer/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Main2 extends StatelessWidget {
  final String doc;
  final Consumer c = Consumer(
    cAddress: Address(city: "", fullAddress: "", pincode: 0, state: ""),
    cBirthDay: "",
    cEmail: "",
    cGender: "",
    cId: "",
    cName: "",
  );
  final FoodListRepo foodListRepo = FoodListRepo([]);
  final OrdersRepo ordersRepo = OrdersRepo();
  Main2(this.doc);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConsumerBloc>(
          create: (_) => ConsumerBloc(c),
        ),
        BlocProvider<FoodBloc>(
          create: (_) => FoodBloc(foodListRepo)..add(GetFood()),
        ),
        BlocProvider<OrdersBloc>(
          create: (_) => OrdersBloc(ordersRepo),
        ),
        BlocProvider<CartBloc>(
          create: (_) => CartBloc(ordersRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'varela',
        ),
        home: FutureBuilder(
          future: consumerRef.document("$doc").get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return loading(context);
            }
            if (!snapshot.data['isRegistered']) {
              return Data(
                consumer: c,
                doc: doc,
              );
            } else {
              return Home(
                cId: doc,
              );
            }
          },
        ),
      ),
    );
  }
}

Container loading(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height / 3,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
