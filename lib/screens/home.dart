import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:consumer/bloc/consumer/consumer_bloc.dart';
import 'package:consumer/firebase_ref.dart';
import 'package:consumer/models/address.dart';
// import 'package:consumer/models/consumer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../screens/productDetail.dart';
import '../utils/utils.dart';
import '../widgets/column_builder.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerHome.dart';

import '../bloc/food/food_bloc.dart';
import '../models/foodItem.dart';

class Home extends StatefulWidget {
  final String cId;

  const Home({Key key, this.cId}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    lowTohigh = 0;
  }

  int lowTohigh;
  List<int> nos = [0, 1, 2];
  List<String> carouselData = [
    "10% discount on your First Order!",
    "Exclusive deals on Plaform Launch!",
    "Find your Favourite Home Chef Now!"
  ];
  List<String> links = [
    "assets/images/chef.png",
    "assets/images/exclusive.png",
    "assets/images/food_delivery.png",
  ];

  thatCarousel() {
    return CarouselSlider(
      aspectRatio: 16 / 9,
      initialPage: 0,
      height: MediaQuery.of(context).size.height * 0.25,
      items: nos.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      carouselData[i],
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      textAlign: TextAlign.left,
                      softWrap: true,
                    ),
                  ),
                  Image.asset(links[i]),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  mealCard(FoodItem foodItem) {
    double stars = 0;
    if (foodItem.rating.isNotEmpty) {
      foodItem.rating.forEach((r) {
        stars += r;
      });
      stars = stars / foodItem.rating.length;
    }
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return ProductDetail(
              foodItem: foodItem,
            );
          }));
        },
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        isThreeLine: true,
        leading: CachedNetworkImage(
          imageUrl: foodItem.fImg,
          fit: BoxFit.cover,
        ),
        title: Text(foodItem.fName, style: TextStyle(fontSize: 17)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(foodItem.pName),
            Row(
              children: <Widget>[
                Text(
                    "${stars.toString().length < 4 ? stars : stars.toString().substring(0, 4)}"),
                SizedBox(width: 10),
                Icon(
                  EvaIcons.star,
                  color: Colors.amber,
                )
              ],
            )
          ],
        ),
        trailing: Text(
          "₹ ${foodItem.price}",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String doc =
        (widget.cId) ?? (BlocProvider.of<ConsumerBloc>(context).consumer.cId);
    void _settingModalBottomSheet(context) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext bc) {
            return Container(
              padding: EdgeInsets.all(20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    child: Text(
                      "Price Low to High",
                      style: TextStyle(
                          color: lowTohigh == 0
                              ? Colors.black
                              : (lowTohigh == 1 ? Colors.green : Colors.black),
                          fontSize: 20),
                    ),
                    onTap: () {
                      setState(() {
                        lowTohigh = 1;
                        Navigator.of(context).pop();
                      });
                      BlocProvider.of<FoodBloc>(context).add(SortAscending());
                    },
                  ),
                  Divider(
                    color: Colors.black45,
                    height: 40,
                  ),
                  GestureDetector(
                    child: Text(
                      "Price High to Low",
                      style: TextStyle(
                          color: lowTohigh == 0
                              ? Colors.black
                              : (lowTohigh == 1 ? Colors.black : Colors.green),
                          fontSize: 20),
                    ),
                    onTap: () {
                      setState(() {
                        lowTohigh = 2;
                        Navigator.of(context).pop();
                      });
                      BlocProvider.of<FoodBloc>(context).add(SortDescending());
                    },
                  )
                ],
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: kolor("e1e2e1"),
      drawer: drawerNav(context), // navigation Drawer Widget in Widgets Library
      appBar: homeAppBar(context),
      body: StreamBuilder(
          stream: consumerRef.document(doc).snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) return loading(context);
            BlocProvider.of<ConsumerBloc>(context).consumer.cAddress = Address(
              city: snapshot.data['cAddress']['city'],
              fullAddress: snapshot.data['cAddress']['fullAddress'],
              pincode: snapshot.data['cAddress']['pincode'],
              state: snapshot.data['cAddress']['state'],
            );
            BlocProvider.of<ConsumerBloc>(context).consumer.cBirthDay =
                snapshot.data['cBirthDay'];
            BlocProvider.of<ConsumerBloc>(context).consumer.cEmail =
                snapshot.data['cEmail'];
            BlocProvider.of<ConsumerBloc>(context).consumer.cGender =
                snapshot.data['cGender'];
            BlocProvider.of<ConsumerBloc>(context).consumer.cName =
                snapshot.data['cName'];
            BlocProvider.of<ConsumerBloc>(context).consumer.cId =
                snapshot.data['cId'];
            return ListView(
              padding: EdgeInsets.only(top: 10, bottom: 100),
              children: <Widget>[
                thatCarousel(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Text(
                        "Choose your Meal",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                        alignment: Alignment.bottomCenter,
                        icon: Icon(
                          EvaIcons.menu2Outline,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          _settingModalBottomSheet(context);
                        }),
                  ],
                ),
                Divider(
                  indent: 10,
                  endIndent: MediaQuery.of(context).size.width * 0.4,
                  color: Colors.black38,
                  thickness: 1,
                ),
                BlocBuilder<FoodBloc, FoodState>(
                  builder: (_, state) {
                    if (state is FoodLoading)
                      return loading(context);
                    else if (state is FoodLoaded)
                      return buildColumnBuilder(state.foodList);
                    else if (state is FoodListAscending)
                      return buildColumnBuilder(state.foodList);
                    else if (state is FoodListDescending)
                      return buildColumnBuilder(state.foodList);
                    return somethingWentWrong();
                  },
                )
              ],
            );
          }),
    );
  }

  ColumnBuilder buildColumnBuilder(List<FoodItem> foodList) {
    return ColumnBuilder(
        itemBuilder: (context, index) {
          return mealCard(foodList[index]);
        },
        itemCount: foodList.length);
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

Container somethingWentWrong() {
  return Container(
    child: Center(
      child: Text("Something Went Wrong!"),
    ),
  );
}
