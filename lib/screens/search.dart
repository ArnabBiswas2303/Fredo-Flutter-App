import 'package:consumer/screens/categoryResults.dart';
import 'package:consumer/screens/searchResults.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../utils/utils.dart';
import '../widgets/drawerNavWidget.dart';
import '../widgets/headerGeneral.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<String> categories = [
    "North Indian",
    "South Indian",
    "Health Plus",
    "Non Veg",
    "Veg",
    "Quick Bites"
  ];
  List<String> kolors = colorList();
  TextEditingController searchController = TextEditingController();
  searchFunction() {
    if (searchController.text.isNotEmpty) {
      String x = searchController.text;
      searchController.clear();
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return SearchResults(x);
      }));
    } else {
      Fluttertoast.showToast(
          msg: "Please enter item to Search!", toastLength: Toast.LENGTH_SHORT);
    }
  }

  searchbar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: searchController,
              cursorColor: Colors.black,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.go,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 15),
                  hintText: "Search"),
            ),
          ),
          IconButton(
            color: Colors.green,
            onPressed: () {
              searchFunction();
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
    );
  }

  grid() {
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      children: List.generate(categories.length, (index) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return CategoryResults(categories[index]);
            }));
          },
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                categories[index],
                softWrap: true,
                textAlign: TextAlign.justify,
                style: TextStyle(
                    fontSize: 30,
                    color: kolor(kolors[index]),
                    fontWeight: FontWeight.w900),
              ),
            ),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kolor("#e1e2e1"),
      drawer: drawerNav(context),
      appBar: headerGeneral("What to eat?"),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20, left: 20, right: 20),
            child: searchbar(),
          ),
          grid(),
        ],
      ),
    );
  }
}
