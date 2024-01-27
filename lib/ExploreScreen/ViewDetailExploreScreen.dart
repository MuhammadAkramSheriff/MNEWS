import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../ArticleProvider.dart';
import '../Common/HomeScreenFormat.dart';

class ViewDetailCategoryScreen extends StatefulWidget {
  String? countryName;
  String? headline;

  ViewDetailCategoryScreen({
    required this.headline,
    this.countryName,
  });

  @override
  State<ViewDetailCategoryScreen> createState() => _ViewDetailCategoryState();
}

class _ViewDetailCategoryState extends State<ViewDetailCategoryScreen> {

  @override
  void initState(){
    super.initState();
    Provider.of<ArticlesProvider>(context, listen: false).clearArticles();
    if (widget.headline?.length == 2) {
      Provider.of<ArticlesProvider>(context, listen: false).fetchArticles(
          "https://newsapi.org/v2/top-headlines?country=${widget.headline}&language=en&apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
    } else {
      Provider.of<ArticlesProvider>(context, listen: false).fetchArticles(
          "https://newsapi.org/v2/top-headlines?category=${widget.headline}&language=en&apiKey=823e1e76df8749a8a5ad7e898a6f59d4");
    }

    if (widget.countryName != null){
      widget.headline = widget.countryName;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      appBar: AppBar(
        title: Text(
          '${widget.headline}',
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
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),

          ),
          child: HomeScreenFormat()
      ),
    );

  }
}