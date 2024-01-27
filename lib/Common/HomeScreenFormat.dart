import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../ArticleModel.dart';
import '../ArticleProvider.dart';
import '../ViewArticle/ViewArticle.dart';
import 'NewsTile.dart';
import 'PublishedTime.dart';

class HomeScreenFormat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ArticlesProvider>( //get data from provider
        builder: (context, articlesProvider, child) {
          List<ArticleDetailsModel> articles = articlesProvider.articleList;
          return ListView.builder( //show data using ListView Builder
            itemCount: articles.length,
            itemBuilder: (context, index) {
              ArticleDetailsModel article = articles[index];
              return Column(
                children: [
                  NewsTile( //call NewsTile widget
                    imageUrl: article.imageUrl ?? '',
                    title: article.title ?? '',
                    description: article.description ?? '',
                    publishedAt: article.publishedAt ?? '',
                    Url: article.url ?? '',
                    articles: articles[index],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: NewsTile( //call NewsTile widget
                          imageUrl: articles[1].imageUrl ?? '',
                          title: articles[1].title ?? '',
                          description: articles[1].description?? '',
                          publishedAt: articles[1].publishedAt ?? '',
                          Url: articles[1].url ?? '',
                          articles: articles[index],
                          textSize: 15,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: NewsTile( //call NewsTile widget
                          imageUrl: articles.length > 2 ? articles[2].imageUrl ?? '' : '',
                          title: articles.length > 2 ? articles[2].title ?? '' : '',
                          description: articles.length > 2 ? articles[2].description ?? '' : '',
                          publishedAt: articles.length > 2 ? articles[2].publishedAt ?? '' : '',
                          Url: articles.length > 2 ? articles[2].url ?? '' : '',
                          articles: articles[index],
                          textSize: 15,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                      ),
                      child: Column(
                          children: [
                            for (int i = 3; i < articles.length; i++)
                              Column(
                                children: [
                                  ListTile( //show data in ListTile format
                                    leading: articles[i].imageUrl != null
                                        ? Container(
                                      width: 100,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            articles[i].imageUrl,
                                          ),
                                        ),
                                      ),
                                    )
                                        : null,
                                    title: Text(articles[i].title ?? '',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                                    subtitle: Text(getTimeDifference(articles[i].publishedAt ?? ''),
                                      style: TextStyle(fontSize: 12, color: Colors.red),),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewArticle(imageUrl: articles[i].imageUrl,
                                              title: articles[i].title,
                                              description: articles[i].description,
                                              publishedAt: articles[i].publishedAt,
                                              Url: articles[i].url
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  Divider(),
                                ],
                              ),
                          ]
                      )
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}