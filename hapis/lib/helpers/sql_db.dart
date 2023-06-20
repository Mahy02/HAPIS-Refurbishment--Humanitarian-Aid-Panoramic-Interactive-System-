import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///This class is responsible for functions related to the database

class SqlDb {
  static Database? _db;

  // Future<Database?> get db async {
  //   if (_db == null) {
  //     _db = await initialDb();
  //     return _db;
  //   } else {
  //     return _db;
  //   }
  // }

  // ///initializing the database and returning the created db
  // initialDb() async {
  //   ///getting database path from flutter built in function
  //   String databasePath = await getDatabasesPath();

  //   ///path + name of database
  //   String path = join(databasePath, 'HAPIS.db');

  //   ///creating the database
  //   Database mydb = await openDatabase(path, onCreate: _onCreate);
  //   return mydb;
  // }

  // _onCreate(Database db, int version) async {
  //   await db.execute('''
  //      CREATE TABLE "users" (
  //       userID AUTOINCREMENT NOT NULL PRIMARY KEY ,

  //      )

  //   ''');
  //   print("create DATABASE & TABLES ");
  // }
}
