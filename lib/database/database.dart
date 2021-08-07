import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "ApiManDb.db";
  static final _databaseVersion = 1;

  static final table = 'ApiMan';

  static final columnId = '_id';
  static final columnUrl = 'url';
  static final columnMethod = 'method';
  static final columnHeaders = 'headers';
  static final columnBody = 'body';
  static final columnResult = 'result';
  static final columnTabId = 'tabId';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    String dbPath = await getDatabasesPath();
    String dataPath = p.join(dbPath, _databaseName);
    print(dataPath);

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = p.join(documentsDirectory.path, _databaseName);
    print(path);
    return await openDatabase(dataPath,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table(
	  $columnId NOT NULL PRIMARY KEY
  , $columnMethod   VARCHAR(10) 
  ,$columnUrl      VARCHAR(225) 
  ,$columnHeaders  TEXT
  ,$columnBody     TEXT
  ,$columnResult TEXT
  ,$columnTabId   INT
);
          ''');
  }

  // Helper methods

  // Inserts a row in the database where each key in the Map is a column name
  // and the value is the column value. The return value is the id of the
  // inserted row.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row,
        conflictAlgorithm: ConflictAlgorithm.replace, nullColumnHack: "");
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryAllRowOrderByTabId() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT  * FROM ApiMan ORDER  BY "tabId" ASC ');
  }

  // All of the methods (insert, query, update, delete) can also be done using
  // raw SQL commands. This method uses a raw query to give the row count.
  Future<int?> queryRowCount() async {
    Database db = await instance.database;
    var i = await db.rawQuery('SELECT COUNT(*) FROM $table');
    return Sqflite.firstIntValue(i);
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Deletes the row specified by the id. The number of affected rows is
  // returned. This should be 1 as long as the row exists.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
