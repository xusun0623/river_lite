// import 'package:sqflite/sqlite_api.dart';

// ///数据表操作基类
// abstract class BaseDBProvider {
//   bool isTableExist = false;

//   tableSqlString();

//   tableName();

//   tabBaseString(String name, String columnId) {
//     return '''
//       create table $name 
//       $columnId integer primary key autoincrement,
//     ''';
//   }

//   Future<Database> getDataBase() async {
//     return await open();
//   }

  
// }
