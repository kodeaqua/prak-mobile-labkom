import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite_crud/models/item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'items.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE items(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          jumlah INTEGER
      )
      ''');
  }

  Future<List<Item>> getItems() async {
    Database db = await instance.database;
    var items = await db.query('items', orderBy: 'name');
    List<Item> itemlist =
        items.isNotEmpty ? items.map((c) => Item.fromMap(c)).toList() : [];
    return itemlist;
  }

  Future<int> add(Item item) async {
    Database db = await instance.database;
    return await db.insert('items', item.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('items', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Item item) async {
    Database db = await instance.database;
    return await db
        .update('items', item.toMap(), where: "id = ?", whereArgs: [item.id]);
  }
}
