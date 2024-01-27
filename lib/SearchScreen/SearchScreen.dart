import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../ArticleModel.dart';
import '../ArticleProvider.dart';
import '../Common/PublishedTime.dart';
import '../ExploreScreen/ExploreScreen.dart';
import '../HomeScreen/HomeScreen.dart';
import '../SavedArticles/SavedArticles.dart';
import '../ViewArticle/ViewArticle.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> articles = [];

  bool isHomeSelected = false;
  bool isExploreSelected = false;
  bool isSearchSelected = true;
  bool isBookmarkSelected = false;

  String searchKey = '';
  String selectedSortOption = 'publishedAt';
  bool isSortOptionsVisible = false;

  // Future<void> getSearchArticles(String searchKey, String sortKey) async {
  //   var getSearchArticlesURL = Uri.parse(
  //       "https://newsapi.org/v2/everything?q=$searchKey&sortBy=$sortKey&apiKey=abe61388c08a4c7dbc194a3bb080ff6b");
  //
  //   try {
  //     http.Response response = await http.get(getSearchArticlesURL);
  //
  //     if (response.statusCode == 200) {
  //       print("Inside 200============================");
  //       Map<String, dynamic> data = jsonDecode(response.body);
  //       print(data);
  //       setState(() {
  //         articles = List<Map<String, dynamic>>.from(data['articles']);
  //       });
  //     } else {
  //       print("Error in response: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error while connecting API: $error");
  //   }
  // }

  @override
  void initState() {
    super.initState();
    Provider.of<ArticlesProvider>(context, listen: false).clearArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Search",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
              children: [
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            border: InputBorder.none,
                          ),
                          onFieldSubmitted: (value) {
                            searchKey = value;

                            //make API request when user submit search
                            Provider.of<ArticlesProvider>(context, listen: false).fetchArticles(
                                "https://newsapi.org/v2/everything?q=$searchKey&sortBy=$selectedSortOption&language=en&"
                                    "apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
                          },
                        ),
                      ),
                      IconButton(
                        icon: Column(
                          children: [
                            Icon(Icons.sort),
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            isSortOptionsVisible = !isSortOptionsVisible;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                if (isSortOptionsVisible)
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[150],
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          height: 40,
                          child: ListTile(
                            title: Text('Sort by date published'),
                            onTap: () {
                              setState(() {
                                selectedSortOption = "publishedAt";

                                //make updated API request for recent publish (sort)
                                Provider.of<ArticlesProvider>(context, listen: false).fetchArticles(
                                    "https://newsapi.org/v2/everything?q=$searchKey&sortBy=$selectedSortOption&language=en&"
                                        "apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
                                isSortOptionsVisible = !isSortOptionsVisible;
                              });
                            },
                          ),
                        ),
                        Divider(
                          height: 0,
                        ),
                        Container(
                          height: 40,
                          child: ListTile(
                            title: Text('Sort by popularity of the source'),
                            onTap: () {
                              setState(() {
                                selectedSortOption = "popularity";

                                //make updated API request for popularity(sort)
                                Provider.of<ArticlesProvider>(context, listen: false).fetchArticles(
                                    "https://newsapi.org/v2/everything?q=$searchKey&sortBy=$selectedSortOption&language=en&"
                                        "apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
                                isSortOptionsVisible = !isSortOptionsVisible;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Color(0xffeeeeee),
                          width: 1.0,
                        ),
                      ),
                    ),
                    child: Consumer<ArticlesProvider>( //display articles using provider
                      builder: (context, articlesProvider, child) {
                        List<ArticleDetailsModel> articles = articlesProvider.articleList;

                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            ArticleDetailsModel article = articles[index];
                            return Column(
                                children: [
                                  ListTile(
                                    leading: articles[index].imageUrl != null
                                        ? Container(
                                      width: 100,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            articles[index].imageUrl,
                                          ),
                                        ),
                                      ),
                                    )
                                        : null,
                                    title: Text(articles[index].title ?? '',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                    subtitle: Text(getTimeDifference(articles[index].publishedAt ?? ''),
                                      style: TextStyle(fontSize: 12, color: Colors.red),),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewArticle(imageUrl: articles[index].imageUrl,
                                              title: articles[index].title,
                                              description: articles[index].description,
                                              publishedAt: articles[index].publishedAt,
                                              Url: articles[index].url
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                ]
                            );

                          },
                        );
                      },
                    ),
                  ),
                )
              ])),
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
                          isSearchSelected = false;
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
                          isSearchSelected = false;
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