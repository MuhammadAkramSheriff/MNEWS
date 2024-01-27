import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../ArticleProvider.dart';
import '../Common/HomeScreenFormat.dart';
import '../ExploreScreen/ExploreScreen.dart';
import '../SavedArticles/SavedArticles.dart';
import '../SearchScreen/SearchScreen.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> articles = [];

  bool isHomeSelected = true;
  bool isExploreSelected = false;
  bool isSearchSelected = false;
  bool isBookmarkSelected = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ArticlesProvider>(context, listen: false).clearArticles();
    Provider.of<ArticlesProvider>(context, listen: false).fetchArticles( //API call using Provider
        "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "MNEWS",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
      ),
      //drawer: CustomDrawer(),
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),

        ),
        child: HomeScreenFormat(),

      ),
      bottomNavigationBar: Wrap(
        runSpacing: 10,
        spacing: 10,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white70,
                  width: 4.0,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(Icons.home,
                              color: isHomeSelected ? Colors.black : Colors.grey),
                          Text("Home"),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          isHomeSelected = true;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()));
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(Icons.menu,
                              color: isExploreSelected ? Colors.black : Colors.grey),
                          Text("Explore"),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          isExploreSelected = true;
                          isHomeSelected = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ExploreScreen()));
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(Icons.search,
                              color: isSearchSelected ? Colors.black : Colors.grey),
                          Text("Search"),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          isSearchSelected = true;
                          isHomeSelected = false;
                          isExploreSelected = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchScreen()));
                      },
                    ),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(Icons.bookmark,
                              color: isBookmarkSelected ? Colors.black : Colors.grey),
                          Text("Search"),
                        ],
                      ),
                      onPressed: () {
                        setState(() {
                          isBookmarkSelected = true;
                          isSearchSelected = false;
                          isHomeSelected = false;
                          isExploreSelected = false;
                        });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SavedArticles()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}