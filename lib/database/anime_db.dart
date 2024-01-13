import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:anima/model/anime.dart';

class AnimeDB {
  static final AnimeDB instance = AnimeDB();

  static Database? _database;
  final String _tableName = "anime";

  static Future<String> databasePath() async {
    final path = await getApplicationDocumentsDirectory();

    return join(path.path, "database", "anima.db");
  }

  Future<Database?> get _openDb async {
    if (_database != null) return _database!;

    final dataBasePath = await databasePath();

    _database =
        await openDatabase(dataBasePath, version: 1, onCreate: _onCreate);

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, title TEXT NOT NULL, image BLOB NOT NULL, studio TEXT NOT NULL, rating TEXT NOT NULL, episodes TEXT NOT NULL, status TEXT NOT NULL, malId INTEGER NOT NULL, episodeWatched INTEGER NOT NULL, animeStatus TEXT NOT NULL)");
  }

  Future<List<Anime>> readAll() async {
    List<Anime> data = [];

    final db = await instance._openDb;
    final res = await db!.query(_tableName);

    for (var i in res) {
      data.add(Anime.fromJSON(i));
    }

    return data;
  }

  Future<int> add(Anime data) async {
    final db = await instance._openDb;
    final id = await db!.insert(_tableName, Anime.toJSON(data));

    return id.toInt();
  }

  Future<void> updateEpisode(int id, int value) async {
    final db = await instance._openDb;

    await db!.update(
        _tableName,
        {
          "episodeWatched": value,
        },
        where: "id = ?",
        whereArgs: [id]);
  }

  Future<void> updateStatus(int id, Status value) async {
    final db = await instance._openDb;

    await db!.update(
        _tableName,
        {
          "status": value.name,
        },
        where: "id = ?",
        whereArgs: [id]);
  }

  Future<void> updateSilent(int id, String rating, String episodes) async {
    final db = await instance._openDb;

    await db!.update(
        _tableName,
        {
          "rating": rating,
          "episodes": episodes,
        },
        where: "id = ?",
        whereArgs: [id]);
  }

  Future<void> delete(int id) async {
    final db = await instance._openDb;

    await db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<void> refresh(
      {required int id,
      required String rating,
      required String episodes,
      required Uint8List image}) async {
    final db = await instance._openDb;

    await db!.update(
        _tableName, {"rating": rating, "episodes": episodes, "image": image},
        where: "malId = ?", whereArgs: [id]);
  }
}
