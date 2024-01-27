import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../ArticleModel.dart';
import '../ArticleProvider.dart';
import '../Common/PublishedTime.dart';
import '../HomeScreen/HomeScreen.dart';
import '../SavedArticles/SavedArticles.dart';
import '../SearchScreen/SearchScreen.dart';
import '../ViewArticle/ViewArticle.dart';
import 'ViewDetailExploreScreen.dart';

class ExploreScreen extends StatefulWidget {
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, List<Map<String, dynamic>>> articles = {};

  bool isHomeSelected = false;
  bool isExploreSelected = true;
  bool isSearchSelected = false;
  bool isBookmarkSelected = false;

  List<String> exploreMenu = ['Category', 'Country'];
  String selectedMenu = 'Category';

  List<String> categories = ['Business', 'Entertainment', 'General', 'Health', 'Science', 'Sports', "Technology"];
  List<Map<String, String>> countries = [
    {'name': 'United Arab Emirates', 'code': 'ae'},
    {'name': 'Argentina', 'code': 'ar'},
    {'name': 'Austria', 'code': 'at'},
    {'name': 'Australia', 'code': 'au'},
    {'name': 'Belgium', 'code': 'be'},
    {'name': 'Bulgaria', 'code': 'bg'},
    {'name': 'Brazil', 'code': 'br'},
    {'name': 'Canada', 'code': 'ca'},
    {'name': 'Switzerland', 'code': 'ch'},
    {'name': 'China', 'code': 'cn'},
    {'name': 'Colombia', 'code': 'co'},
    {'name': 'Cuba', 'code': 'cu'},
    {'name': 'Czech Republic', 'code': 'cz'},
    {'name': 'Germany', 'code': 'de'},
    {'name': 'Egypt', 'code': 'eg'},
    {'name': 'France', 'code': 'fr'},
    {'name': 'United Kingdom', 'code': 'gb'},
    {'name': 'Greece', 'code': 'gr'},
    {'name': 'Hong Kong', 'code': 'hk'},
    {'name': 'Hungary', 'code': 'hu'},
    {'name': 'Indonesia', 'code': 'id'},
    {'name': 'Ireland', 'code': 'ie'},
    {'name': 'Israel', 'code': 'il'},
    {'name': 'India', 'code': 'in'},
    {'name': 'Italy', 'code': 'it'},
    {'name': 'Japan', 'code': 'jp'},
    {'name': 'South Korea', 'code': 'kr'},
    {'name': 'Lithuania', 'code': 'lt'},
    {'name': 'Latvia', 'code': 'lv'},
    {'name': 'Morocco', 'code': 'ma'},
    {'name': 'Mexico', 'code': 'mx'},
    {'name': 'Malaysia', 'code': 'my'},
    {'name': 'Nigeria', 'code': 'ng'},
    {'name': 'Netherlands', 'code': 'nl'},
    {'name': 'Norway', 'code': 'no'},
    {'name': 'New Zealand', 'code': 'nz'},
    {'name': 'Philippines', 'code': 'ph'},
    {'name': 'Poland', 'code': 'pl'},
    {'name': 'Portugal', 'code': 'pt'},
    {'name': 'Romania', 'code': 'ro'},
    {'name': 'Serbia', 'code': 'rs'},
    {'name': 'Russia', 'code': 'ru'},
    {'name': 'Saudi Arabia', 'code': 'sa'},
    {'name': 'Sweden', 'code': 'se'},
    {'name': 'Singapore', 'code': 'sg'},
    {'name': 'Slovakia', 'code': 'sk'},
    {'name': 'Thailand', 'code': 'th'},
    {'name': 'Turkey', 'code': 'tr'},
    {'name': 'Taiwan', 'code': 'tw'},
    {'name': 'Ukraine', 'code': 'ua'},
    {'name': 'United States', 'code': 'us'},
    {'name': 'Venezuela', 'code': 've'},
    {'name': 'South Africa', 'code': 'za'},
  ];

  void fetchArticlesForSelectedMenu() {
    if (selectedMenu == 'Category') {
      for (String category in categories) {
        Provider.of<ArticlesProvider>(context, listen: false).fetchArticlesForExplore(category,
            "https://newsapi.org/v2/top-headlines?category=$category&language=en&"
                "apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
      }
    } else {
      for (Map<String, String> country in countries) {
        Provider.of<ArticlesProvider>(context, listen: false).fetchArticlesForExplore(
            country['code']!,
            "https://newsapi.org/v2/top-headlines?country=${country['code']}&language="
                "en&apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: exploreMenu.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedMenu = exploreMenu[_tabController.index];
        fetchArticlesForSelectedMenu();
      });
    });

    Provider.of<ArticlesProvider>(context, listen: false).clearArticles();
    fetchArticlesForSelectedMenu();
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: const Text(
            "Explore",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: TabBar(
              controller: _tabController,
              tabs: exploreMenu.map((menu) => Tab(text: menu)).toList(),
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 3,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildCategoryContent(),
                buildCountryContent(),
              ],
            ),
          ),
        ],
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
                          isExploreSelected = false;
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

  //Category tab widget
  Widget buildCategoryContent() {
    return SingleChildScrollView(
      child: Column(
        children: categories.map((category) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewDetailCategoryScreen(headline: category),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xffeeeeee),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Consumer<ArticlesProvider>(
                  builder: (context, articlesProvider, child) {
                    Map<String, List<ArticleDetailsModel>> articlesForExplore = articlesProvider.articlesForExplore;
                    List<ArticleDetailsModel> articles = articlesForExplore[category] ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: articles.length > 2 ? 2 : articles.length,
                      itemBuilder: (context, index) {
                        ArticleDetailsModel article = articles[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: articles[index].imageUrl.isNotEmpty
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
                              title: Text(
                                articles[index].title ?? '',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
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
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget buildCountryContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: countries.map((country) {
          String countryName = country['name'] ?? '';
          String countryCode = country['code'] ?? '';
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  children: [
                    Text(
                      countryName,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Column(
                        children: [
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewDetailCategoryScreen(countryName: countryName, headline: countryCode),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xffeeeeee),
                      width: 1.0,
                    ),
                  ),
                ),
                child: Consumer<ArticlesProvider>(
                  builder: (context, articlesProvider, child) {
                    Map<String, List<ArticleDetailsModel>> articlesForExplore = articlesProvider.articlesForExplore;
                    List<ArticleDetailsModel> articles = articlesForExplore[countryCode] ?? [];

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: articles.length > 2 ? 2 : articles.length,
                      itemBuilder: (context, index) {
                        ArticleDetailsModel article = articles[index];
                        return Column(
                          children: [
                            ListTile(
                              leading: article.imageUrl != null
                                  ? Container(
                                width: 100,
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      article.imageUrl,
                                    ),
                                  ),
                                ),
                              )
                                  : null,
                              title: Text(
                                article.title ?? '',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(getTimeDifference(article.publishedAt ?? ''),
                                style: TextStyle(fontSize: 12, color: Colors.red),),
                              onTap: () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewArticle(imageUrl: article.imageUrl,
                                        title: article.title,
                                        description: article.description,
                                        publishedAt: article.publishedAt,
                                        Url: article.url
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              )
            ],
          );
        }).toList(),
      ),
    );
  }
}