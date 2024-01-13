import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:anima/model/profile.dart';

class ProfileDB {
  static final ProfileDB instance = ProfileDB();

  static Database? _database;
  final String _tableName = "profile";

  Future<Database?> get _openDb async {
    if (_database != null) return _database!;

    final path = await getApplicationDocumentsDirectory();

    final dataBasePath = join(path.path, "database", "profile.db");

    _database =
        await openDatabase(dataBasePath, version: 1, onCreate: _onCreate);

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, name TEXT NOT NULL, image TEXT NOT NULL)");
  }

  Future<Profile> read() async {
    final db = await instance._openDb;
    final res = await db!.query(_tableName);

    return Profile.fromJSON(res[0]);
  }

  Future<int> add(Profile data) async {
    final db = await instance._openDb;
    final id = await db!.insert(_tableName, data.toJSON());

    return id.toInt();
  }
}
