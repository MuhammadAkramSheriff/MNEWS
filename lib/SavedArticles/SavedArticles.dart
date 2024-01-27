import 'package:flutter/material.dart';
import '../Common/PublishedTime.dart';
import '../DatabaseConnection.dart';
import '../ViewArticle/ViewArticle.dart';

class SavedArticles extends StatefulWidget {
  @override
  State<SavedArticles> createState() => _SavedArticlesState();
}

class _SavedArticlesState extends State<SavedArticles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Saved",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: FutureBuilder<List<Map<String, dynamic>>>( //get data from database
          future: databaseConnection.instance.queryAll(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> savedArticles = snapshot.data ?? [];
              return ListView.builder( //build using ListView Builder
                itemCount: savedArticles.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> article = savedArticles[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: article['urlToImage'] != null
                              ? Container(
                            width: 100,
                            height: 80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(article['urlToImage']),
                              ),),
                          ) : null,
                          title: Text(article['title'] ?? '',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                          subtitle: Text(getTimeDifference(article['publishedAt'] ?? ''),
                            style: TextStyle(fontSize: 12, color: Colors.red),),
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewArticle(
                                  imageUrl: article['urlToImage'],
                                  title: article['title'],
                                  description: article['description'],
                                  publishedAt: article['publishedAt'],
                                  Url: article['url'],
                                ),
                              ),
                            ).then((result) {
                              if (result != null && result == true) {
                                setState(() {});
                              }
                            });
                          },
                        ),
                        Divider(),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}