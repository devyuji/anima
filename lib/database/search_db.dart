import 'package:anima/model/search_history.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SearchDB {
  static final SearchDB instance = SearchDB();

  static Database? _database;
  final String _tableName = "search";

  Future<Database?> get _openDb async {
    if (_database != null) return _database!;

    final path = await getApplicationDocumentsDirectory();

    final dataBasePath = join(path.path, "database", "search.db");

    _database =
        await openDatabase(dataBasePath, version: 1, onCreate: _onCreate);

    return _database;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "CREATE TABLE $_tableName (id INTEGER PRIMARY KEY, text TEXT NOT NULL)");
  }

  Future<List<SearchHistory>> readAll() async {
    List<SearchHistory> data = [];

    final db = await instance._openDb;
    final res = await db!.query(_tableName);

    for (var i in res) {
      data.add(SearchHistory.fromJSON(i));
    }

    return data;
  }

  Future<int> add(SearchHistory data) async {
    final db = await instance._openDb;
    final id = await db!.insert(_tableName, data.toJSON());

    return id.toInt();
  }

  Future<void> delete(int id) async {
    final db = await instance._openDb;

    await db!.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }
}
