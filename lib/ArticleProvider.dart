import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


import 'ArticleModel.dart';

class ArticlesProvider extends ChangeNotifier {
  List<ArticleDetailsModel> _articleList = [];
  Map<String, List<ArticleDetailsModel>> _articlesForExplore = {};

  Map<String, List<ArticleDetailsModel>> get articlesForExplore => _articlesForExplore;
  List<ArticleDetailsModel> get articleList => _articleList;

  Future<void> fetchArticles(String url) async {
      try {
        //make request
        http.Response response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          //fetch response
          List<dynamic> dataList = jsonDecode(response.body)['articles'];
          print(dataList);
          _articleList = dataList
              .map((data) => ArticleDetailsModel.fromJson(data))
              .toList();
          //notify listeners
          notifyListeners();
        } else {
          print("Error in response: ${response.statusCode}");
        }
      } catch (error) {
        print("Error while connecting API: $error");
      }
  }

  Future<void> fetchArticlesForExplore(String identifier, String url) async {
      try {
        //make request
        http.Response response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          //fetch response
          List<dynamic> dataList = jsonDecode(response.body)['articles'];
          print(dataList);
          List<ArticleDetailsModel> articlesForCategory =
          dataList.map((data) => ArticleDetailsModel.fromJson(data)).toList();

          _articlesForExplore[identifier] = articlesForCategory;
          notifyListeners();
        } else if (response.statusCode == 429) {
          print("Inside 429============================");
          await Future.delayed(Duration(seconds: 5));
          await fetchArticlesForExplore(identifier, url);
        } else {
          print("Error in response: ${response.statusCode}");
        }
      } catch (error) {
        print("Error while connecting API: $error");
      }
  }

  void clearArticles() {
    _articleList.clear();
  }
}