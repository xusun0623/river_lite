import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBManager {
  ///数据库版本
  static const int _VERSION = 1;

  ///数据库名称
  static const String _DB_NAME = "collect.db";

  ///数据库示例
  static Database _database;

  static init() async {
    var databasePath = await getDatabasesPath();
    String dbName = _DB_NAME;
    String path = databasePath + dbName;
    if (Platform.isIOS) {
      path = databasePath + "/" + dbName;
    }

    _database = await openDatabase(
      path,
      version: _VERSION,
      onCreate: (Database db, int version) async {
        ///创建表
        await db.execute(
          'CREATE TABLE Test (id INTEGER PRIMARY KEY, name TEXT, value INTEGER, num REAL)',
        );
      },
    );
  }

  ///判断指定表是否已经存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    String sql =
        "select * from Sqlite_master where type = 'table' and name = '$tableName'";
    var res = await _database.rawQuery(sql);
    print("$res");
    return res != null && res.length > 0;
  }

  ///获取当前的数据库示例
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }
}
