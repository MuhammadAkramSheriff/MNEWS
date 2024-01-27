import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../ArticleModel.dart';
import '../ViewArticle/ViewArticle.dart';
import 'PublishedTime.dart';

class NewsTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String publishedAt;
  final String Url;
  final ArticleDetailsModel articles;
  final double textSize;

  NewsTile({
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.publishedAt,
    required this.Url,
    required this.articles,
    this.textSize = 18.0
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewArticle(imageUrl: imageUrl,
                title: title,
                description: description,
                publishedAt: publishedAt,
                Url: Url
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            imageUrl.isNotEmpty
                ? Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            )
                : Container(),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontSize: textSize, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              description,
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Text(
              getTimeDifference(publishedAt),
              style: TextStyle(fontSize: 14, color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}