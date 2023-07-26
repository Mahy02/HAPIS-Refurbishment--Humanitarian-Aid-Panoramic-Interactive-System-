import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart';

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
    ///Open the database or create it if it doesn't exist by calling 'openDatabase' which takes the `path` and `onCreate` call back method and `onUograde` call back method as well as the `version`
    ///The version is needed when we want to update something in our database, like adding a table or deleted a table or so on
    ///Instead of dropping the database and creating it again
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  /// [deleteDb] method that drops the database by calling the [deleteDatabase] function that takes in the database `path`
  Future<void> deleteDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'HAPIS.db');

    await deleteDatabase(path);
  }

  ///`_onCreate` function that gets called once the database is created, it creates 4 tables  --IT IS CALLED ONLY ONCE
  _onCreate(Database db, int version) async {
    //Note we didnt use autoincrement due to the reason stated in this documentation: https://www.sqlitetutorial.net/sqlite-autoincrement/
    await db.execute('''
       CREATE TABLE IF NOT EXISTS Users (
        UserID TEXT  NOT NULL PRIMARY KEY ,
        UserName TEXT NOT NULL,
        FirstName TEXT NOT NULL,
        LastName TEXT NOT NULL,
        City TEXT NOT NULL ,
        Country TEXT NOT NULL,
        AddressLocation TEXT NOT NULL,
        PhoneNum TEXT NOT NULL,
        Email TEXT NOT NULL,
        Password TEXT,
        UNIQUE(UserID)
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
        For TEXT NOT NULL  CHECK (For IN ('self', 'other', '')) ,
        Status TEXT NOT NULL CHECK (Status IN ('Completed', 'Not Completed')) ,
        FOREIGN KEY (UserID) REFERENCES Users(UserID),
        UNIQUE(FormID)		 		
       );
    ''');

    await db.execute('''
       CREATE TABLE IF NOT EXISTS Matchings (
        M_ID INTEGER  NOT NULL PRIMARY KEY ,
        Seeker_FormID INTEGER NOT NULL,
        Giver_FormID INTEGER NOT NULL,
        Rec1_Status  TEXT NOT NULL  CHECK (Rec1_Status IN ('Pending', 'Accepted', 'Rejected')) ,
        Rec2_status TEXT NOT NULL CHECK (Rec2_status IN ('Pending', 'Accepted', 'Rejected')) ,
        Donation_Status TEXT NOT NULL CHECK (Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        FOREIGN KEY (Seeker_FormID) REFERENCES Forms(FormID),
        FOREIGN KEY (Giver_FormID) REFERENCES Forms(FormID),
        UNIQUE(M_ID)
       );
    ''');

    await db.execute('''
       CREATE TABLE IF NOT EXISTS Requests (
        R_ID INTEGER  NOT NULL PRIMARY KEY ,
        Sender_ID INTEGER NOT NULL,
        Rec_ID INTEGER NOT NULL,
        Rec_FormID INTEGER NOT NULL,
        Rec_Status  TEXT NOT NULL  CHECK (Rec_Status IN ('Pending', 'Accepted', 'Rejected')) ,
        Donation_Status TEXT NOT NULL CHECK (Donation_Status IN ('Not Started', 'In progress', 'Finished', 'Cancelled')) ,
        FOREIGN KEY (Rec_FormID) REFERENCES Forms(FormID),
        FOREIGN KEY (Sender_ID) REFERENCES Users(UserID),
        FOREIGN KEY (Rec_ID) REFERENCES Users(UserID),
        UNIQUE(R_ID)
       );
    ''');
  }

  ///`_onUpgrade` function
  _onUpgrade(Database db, int oldVersion, int newVersion) {}

  ///`readData` that returns a response from the SELECT sql query statment where it takes  [selectSql] string for the sql query
  readData(String selectSql) async {
    Database? hapisDb = await db;
    List<Map> response = await hapisDb!.rawQuery(selectSql);
    return response;
  }

  ///`insertData` that uses INSERT statment given to the function as string  [selectSql] to insert a new row in a table and return the last inserted rowID
  insertData(String selectSql) async {
    Database? hapisDb = await db;
    int response = await hapisDb!.rawInsert(selectSql);
    return response;
  }

  ///`updateData` that uses UPDATE statment given to the function as string  [selectSql]  to update a row in a table and return the number of changes made
  updateData(String selectSql) async {
    Database? hapisDb = await db;
    int response = await hapisDb!.rawUpdate(selectSql);
    return response;
  }

  ///`deleteData` that uses DELETE statment given to the function as string  [selectSql]  to delete a row in a table and return the number of changes made
  deleteData(String selectSql) async {
    Database? hapisDb = await db;
    int response = await hapisDb!.rawDelete(selectSql);
    return response;
  }

  ///`importTableFromCSV` function that takes in [tableName] & [csvFileName] to import tables from a given csv file into the database
  Future<void> importTableFromCSV(String tableName, String csvFileName) async {
    /// Read the CSV file from assets
    String csvString = await rootBundle.loadString('assets/$csvFileName');

    /// Parse the CSV string
    List<List<dynamic>> csvData = const CsvToListConverter().convert(csvString);

    /// Get a reference to the database
    Database? hapisDb = await db;

    /// Start a database transaction
    await hapisDb!.transaction((txn) async {
      for (int rowIndex = 1; rowIndex < csvData.length; rowIndex++) {
        Map<String, dynamic> rowData = {};

        for (int i = 0; i < csvData[rowIndex].length; i++) {
          String columnName = csvData[0][i].toString();

          dynamic columnValue = csvData[rowIndex][i];

          rowData[columnName] = columnValue;
        }

        /// Insert the row into the table
        try {
          await txn.insert(tableName, rowData);
        } catch (e) {
          // if the insert fails due to a unique constraint violation, ignore the error
          if (e is DatabaseException && e.isUniqueConstraintError()) {
            print('Ignoring duplicate row: $rowData');
          } else {
            // re-throw the exception if it's not a unique constraint violation
            throw e;
          }
        }
      }
    });
  }

  /// `importAllTablesFromCSV` Function to import all tables from CSV files where it calls the  [importTableFromCSV] method
  Future<void> importAllTablesFromCSV() async {
    /// Import Users table
    await importTableFromCSV('Users', 'Users.csv');

    /// Import Forms table
    await importTableFromCSV('Forms', 'Forms.csv');

    /// Import Matchings table
    await importTableFromCSV('Matchings', 'Matchings.csv');

    /// Import Requests table
    await importTableFromCSV('Requests', 'Requests.csv');
  }
}
