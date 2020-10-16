import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/models.dart';
import 'dart:io';

class DBHelper {
  DBHelper._();
  static final DBHelper _db = DBHelper._();
  factory DBHelper() => _db;

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'ArmyTrainer.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE push(
            date TEXT PRIMARY KEY,
            countRecord INTEGER,
            countLevel INTEGER
          )''');
      await db.execute('''
          CREATE TABLE sit(
            date TEXT PRIMARY KEY,
            countRecord INTEGER,
            countLevel INTEGER
          )
        ''');
    }, onUpgrade: (db, oldVersion, newVersion) {});
  }

  //Create
  createPushData(Push push) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO push VALUES(?, ?, ?)',
        [push.date, push.countRecord, push.countLevel]);
    return res;
  }

  createSitData(Sit sit) async {
    final db = await database;
    var res = await db.rawInsert('INSERT INTO sit VALUES(?, ?, ?)',
        [sit.date, sit.countRecord, sit.countLevel]);
    return res;
  }

  //Read
  getPush(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM push WHERE date = ?', [date]);
    return res.isNotEmpty
        ? Push(
            date: res.first['date'],
            countRecord: res.first['countRecord'],
            countLevel: res.first['countLevel'])
        : Null;
  }

  getSit(String date) async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM sit WHERE date = ?', [date]);
    return res.isNotEmpty
        ? Push(
            date: res.first['date'],
            countRecord: res.first['countRecord'],
            countLevel: res.first['countLevel'])
        : Null;
  }

  //Read All
  Future<List<Push>> getAllPush() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM push');
    List<Push> list = res.isNotEmpty
        ? res
            .map((c) => Push(
                date: c['date'],
                countRecord: c['countRecord'],
                countLevel: c['countLevel']))
            .toList()
        : [];
    return list;
  }

  Future<List<Push>> getAllSit() async {
    final db = await database;
    var res = await db.rawQuery('SELECT * FROM sit');
    List<Push> list = res.isNotEmpty
        ? res
            .map((c) => Push(
                date: c['date'],
                countRecord: c['countRecord'],
                countLevel: c['countLevel']))
            .toList()
        : [];
    return list;
  }

  //Update
  updatePush(Push push) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE push SET countRecord = ?, countLevel = ? WHERE date = ?',
        [push.countRecord, push.countLevel, push.date]);
    return res;
  }

  updateSit(Sit sit) async {
    final db = await database;
    var res = db.rawUpdate(
        'UPDATE sit SET countRecord = ?, countLevel = ? WHERE date = ?',
        [sit.countRecord, sit.countLevel, sit.date]);
    return res;
  }
}
