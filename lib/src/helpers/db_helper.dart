import 'dart:async';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

import '../constants/database.dart' as DBConstants;

// class DBHelper {
//   static inse
// }

int _version = 1;

Future<sql.Database> _database() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, DBConstants.dbName),
    onCreate: (db, version) async {
      await db.execute(DBConstants.sqlPlaces);
    },
    version: _version,
  );
  return db;
}

Future<void> insert(String table, Map<String, Object> data) async {
  await _database()
    ..insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
}

Future<List<Map<String, dynamic>>> select(String table) async {
  final db = await _database();
  return db.query(table);
}
