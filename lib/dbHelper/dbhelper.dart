import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

import 'package:sqlite_flutter/models/item.dart';

class DBHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute('''
      CREATE TABLE barangs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
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
  static Future<int> createItem(Barang barang) async {
    final db = await DBHelper.db();

    int id = await db.insert('barangs', barang.toMap(), 
    conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items
  static Future<List<Barang>> getItemList() async {
    final db = await DBHelper.db();
    var mapList = await db.query('barangs', orderBy: 'name');
    int count = mapList.length;

    List<Barang> itemList = [];
    for (int i = 0; i < count; i++) {
      itemList.add(Barang.fromMap(mapList[i]));
    }

    return itemList;
  }

  // Read a single item by id
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await DBHelper.db();
    var item = await db.query('barangs', where: 'id=?', whereArgs: [id], limit: 1);
    return item;
  }

  // Update an item by id
  static Future<int> updateItem(Barang barang) async {
    final db = await DBHelper.db();
    final result = await db.update('barangs', barang.toMap(), where: 'id=?', whereArgs: [barang.id]);
    return result;
  }
  
  //Delete an item by id
  static Future<void> deleteItem(int id) async {
    final db = await DBHelper.db();
    try {
      await db.delete('barangs', where: 'id=?', whereArgs: [id]);
    } catch (err) {
      debugPrint("Kesalahan menghapus item: $err");
    }
  }
}
