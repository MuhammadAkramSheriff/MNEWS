import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../DatabaseConnection.dart';
import '../ArticleModel.dart';
import '../Common/toastMessage.dart';


class ViewArticle extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String publishedAt;
  final String Url;

  ViewArticle({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.Url,
  });

  @override
  _ViewArticleState createState() => _ViewArticleState();
}

class _ViewArticleState extends State<ViewArticle> {
  late final WebViewController _controller;
  bool isBookmarked = false;

  //to check if the article is already saved and update bookmark status
  void checkBookmarkStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isBookmarked = prefs.getBool(widget.title) ?? false;
    });
  }

  void saveArticle() async {
    //verify is article already saved
    var isAlreadySaved = await databaseConnection.instance.isArticleSaved(widget.title);

    setState(() {
      isBookmarked = !isAlreadySaved;
    });

    if (isAlreadySaved) { //if already saved, unsave the article
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(widget.title, false);
      await databaseConnection.instance.deleteArticle(widget.title);
      showToast('Removed from bookmarks', context);
    } else { //save the article
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(widget.title, true);
      await databaseConnection.instance.saveArticle(
        imageUrl: widget.imageUrl,
        title: widget.title,
        description: widget.description,
        publishedAt: widget.publishedAt,
        url: widget.Url,
      );
      showToast('Saved', context);
    }

    setState(() {
      Future.delayed(Duration.zero, () {
        checkBookmarkStatus();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();

    //WebViewWidget instance
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..loadRequest(Uri.parse(widget.Url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: () {
              saveArticle();
            },
          ),
        ],
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}