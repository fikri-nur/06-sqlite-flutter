import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

// import 'package:sqlite_flutter/models/item.dart';

class DBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE barangs (
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        price INTEGER
      )
    ''');
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'fikri.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item
  static Future<int> createItem(String name, int price) async {
    final db = await DBHelper.db();

    final data = {
      'name': name, 
      'price': price,};
    final id = await db.insert('barangs', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await DBHelper.db();
    return db.query('barangs', orderBy: "id");
  }

  // Read a single item by id
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DBHelper.db();
    return db.query('barangs', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String name, int price) async {
    final db = await DBHelper.db();

    final data = {
      'name': name,
      'price': price,
    };
    final result =
        await db.update('barangs', data, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //Delete an item by id
  static Future<void> deleteItem(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete("barangs", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
