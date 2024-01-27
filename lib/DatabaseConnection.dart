import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

import 'ArticleModel.dart';

class databaseConnection {
  static Database? _db;

  //database creation following singletion pattern
  databaseConnection._privateConstructor();

  //instance of the class
  static final databaseConnection instance = databaseConnection
      ._privateConstructor();

  //variables are used for consistant naming
  static const String DB_Name = 'mnews'; //Database name
  static const String Table_Articles = 'Saved_Articles'; //Table name
  static const int Version = 1;

  //column names
  static const String Article_Title = 'title';
  static const String Article_Description = 'description';
  static const String Article_PublishedAt = 'publishedAt';
  static const String Article_ImageUrl = 'urlToImage';
  static const String Article_Url = 'url';

  //getter for the database instance
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  //initialize the database
  initDb() async {
    final databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DB_Name);
    var db = await openDatabase(
        path, version: Version, onCreate: _onCreate);
    return db;
  }

  //create the table
  _onCreate(Database db, int intVersion) async {
    await db.execute('''
      CREATE TABLE $Table_Articles (
        $Article_ImageUrl TEXT,
        $Article_Title TEXT,
        $Article_Description TEXT,
        $Article_PublishedAt TEXT,
        $Article_Url TEXT
      )
    ''');
  }

  //save articles into database
  Future<int> saveArticle({
    required String imageUrl,
    required String title,
    required String description,
    required String publishedAt,
    required String url,
  }) async {
    var dbClient = await db;
    var res = await dbClient.insert(Table_Articles, {
      Article_ImageUrl: imageUrl,
      Article_Title: title,
      Article_Description: description,
      Article_PublishedAt: publishedAt,
      Article_Url: url,
    });
    return res;
  }

  //query all
  Future<List<Map<String, dynamic>>> queryAll() async {
    var dbClient = await db;
    var res = await dbClient.query(Table_Articles);
    return res;
  }

  //to check if the article already saved
  Future<bool> isArticleSaved(String title) async {
    var dbClient = await db;
    var res = await dbClient.query(
      Table_Articles,
      where: '$Article_Title = ?',
      whereArgs: [title],
    );
    return res.isNotEmpty;
  }

  //delete a article by title
  Future<void> deleteArticle(String articleTitle) async {
    final dbClient = await db;
    final res = await dbClient.delete(
      Table_Articles,
      where: '$Article_Title = ?',
      whereArgs: [articleTitle],
    );
  }
}