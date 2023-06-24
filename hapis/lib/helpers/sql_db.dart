import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

///This class [SqlDb] is responsible for functions related to the database

class SqlDb {
  ///private `_db` object to hold all things related to the database and access all the functionalities of the `SqlDb` class
  static Database? _db;

  /// `db` get method to be able to retrieve the private `db` later.
  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  /// `initialDb` initializing the database and returning the created db after calling `_onCreate` when calling `openDatabase`
  initialDb() async {
    ///getting database path from flutter built in function
    String databasePath = await getDatabasesPath();

    ///path + name of database
    String path = join(databasePath, 'HAPIS.db');

    ///creating the database
    ///The version is needed when we want to update something in our database, like adding a table or deleted a table or so on
    ///Instead of dropping the database and creating it again
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  ///`_onCreate` function that gets called once the database is created, it creates 4 tables  --IT IS CALLED ONLY ONCE

  _onCreate(Database db, int version) async {
    //Note we didnt use autoincrement due to the reason stated in this documentation: https://www.sqlitetutorial.net/sqlite-autoincrement/
    await db.execute('''
       CREATE TABLE IF NOT EXISTS Users (
        UserID INTEGER  NOT NULL PRIMARY KEY ,
        UserName TEXT NOT NULL,
        FirstName TEXT NOT NULL,
        LastName TEXT NOT NULL,
        Country TEXT NOT NULL,
        City NOT NULL TEXT,
        AddressLocation NOT NULL TEXT,
        PhoneNum NOT NULL TEXT,
        Email NOT NULL TEXT,
        Password NOT NULL TEXT
       );
    ''');

    await db.execute('''
       CREATE TABLE IF NOT EXISTS Forms (
        FormID INTEGER  NOT NULL PRIMARY KEY ,
        UserID INTEGER NOT NULL,
        Type TEXT NOT NULL CHECK (Type IN ('seeker', 'giver')) ,
        Item TEXT NOT NULL,
        Category TEXT NOT NULL CHECK (Category IN ('Clothing', 'Household', 'Books and Media', 'Toys and Games', 'Sports Equipment', 'Baby item', 'Hygiene Products', 'Medical Supplies', 'Pet supplies', 'Food', 'Electronics')) ,
        Dates_available TEXT NOT NULL,
        For TEXT NOT NULL  CHECK (For IN ('self', 'other')) ,
        Status TEXT NOT NULL CHECK (Status IN ('Completed', 'Not Completed')) ,
        FOREIGN KEY (UserID) REFERENCES Users(UserID) 		 		
       );
    ''');

    await db.execute('''
       CREATE TABLE IF NOT EXISTS Matchings (
        M_ID INTEGER  NOT NULL PRIMARY KEY ,
        Seeker_FormID INTEGER NOT NULL,
        Giver_FormID INTEGER NOT NULL,
        Rec1_Status  TEXT NOT NUL  CHECK (Rec1_Status IN ('Pending', 'Accepted', 'Rejected')) ,
        Rec2_status TEXT NOT NUL CHECK (Rec2_status IN ('Pending', 'Accepted', 'Rejected')) ,
        Donation_Status TEXT NOT NUL CHECK (Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        FOREIGN KEY (Seeker_FormID) REFERENCES Forms(FormID),
        FOREIGN KEY (Giver_FormID) REFERENCES Forms(FormID)
       );
    ''');

    await db.execute('''
       CREATE TABLE IF NOT EXISTS Requests (
        R_ID INTEGER  NOT NULL PRIMARY KEY ,
        Sender_ID INTEGER NOT NULL,
        Rec_ID INTEGER NOT NULL,
        Rec_FormID INTEGER NOT NULL,
        Rec_Status  TEXT NOT NUL  CHECK (Rec_Status IN ('Pending', 'Accepted', 'Rejected')) ,
        Donation_Status TEXT NOT NUL CHECK (Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        FOREIGN KEY (Rec_FormID) REFERENCES Forms(FormID),
        FOREIGN KEY (Sender_ID) REFERENCES Users(UserID),
        FOREIGN KEY (Rec_ID) REFERENCES Users(UserID)
       );
    ''');
    print("create DATABASE & TABLES ");
  }

  ///`_onUpgrade` function that
  _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("==onUpgrade==");
  }

  ///`readData` that returns a response coming out of a SELECT sql query statment
  readData(String selectSql) async {
    Database? hapisDb = await db;
    List<Map> response = await hapisDb!.rawQuery(selectSql);
    return response;
  }

  ///`insertData` that uses INSERT statment to insert a new row in a table and return the last inserted rowID
  insertData(String selectSql) async {
    Database? hapisDb = await db;
    int response = await hapisDb!.rawInsert(selectSql);
    return response;
  }

  ///`updateData` that uses UPDATE statment to update a row in a table and return the number of changes made
  updateData(String selectSql) async {
    Database? hapisDb = await db;
    int response = await hapisDb!.rawUpdate(selectSql);
    return response;
  }

  ///`deleteData` that uses DELETE statment to delete a row in a table and return the number of changes made
  deleteData(String selectSql) async {
    Database? hapisDb = await db;
    int response = await hapisDb!.rawDelete(selectSql);
    return response;
  }
}
