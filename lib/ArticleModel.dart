class ArticleDetailsModel {
  late String imageUrl;
  late String title;
  late String description;
  late String publishedAt;
  late String url;

  ArticleDetailsModel({required this.imageUrl,required this.title, required this.description,
    required this.publishedAt, required this.url});

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{
      'urlToImage': imageUrl,
      'title': title,
      'description': description,
      'publishedAt': publishedAt,
      'url': url,
    };
    return map;
  }

  factory ArticleDetailsModel.fromJson(Map<String, dynamic> data) {
    return ArticleDetailsModel(
      imageUrl: data['urlToImage'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      publishedAt: data['publishedAt'] ?? '',
      url: data['url'] ?? '',
    );
  }

// DateTime parseDateString(DateTime dateString) {
//   try {
//     return DateTime.parse(dateString);
//   } catch (e) {
//     // Handle the case where the date string is not in the expected format
//     print('Error parsing date: $dateString');
//     return DateTime.now(); // or return a default date
//   }
// }
}