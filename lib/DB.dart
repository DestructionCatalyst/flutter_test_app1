

import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'ClientModel.dart';

class DBProvider {

  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  Future<Database> get database async {
    if (_database != null)
      return _database;

    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = (documentsDirectory.path + "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {
    }, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Client ("
          "id INTEGER PRIMARY KEY,"
          "word_pair TEXT"
          ")");
    });
  }

  newClient(Client newClient) async {
    final db = await database;
    var res = await db.insert("Client", newClient.toJson());

    return res;
  }

  Future<List<Client>> getAllClients() async {
    final db = await database;
    //var res = await db.query("Client");
    var res = await db.rawQuery("SELECT * FROM Client ORDER BY word_pair");
    List<Client> list =
    res.isNotEmpty ? res.map((c) => Client.fromJson(c)).toList() : [];
    return list;
  }

  Future<bool> contains(String wordPair) async {
    final db = await database;

    var res = await db.query("Client", where: "word_pair = ?", whereArgs: [wordPair] );

    return res.isNotEmpty;
  }
  /*
  deleteClient(int id) async {
    final db = await database;
    db.delete("Client", where: "id = ?", whereArgs: [id]);
  }
   */
  deleteClient(String wordPair) async {
    final db = await database;
    db.delete("Client", where: "word_pair = ?", whereArgs: [wordPair]);
  }
}