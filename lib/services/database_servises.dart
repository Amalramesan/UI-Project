import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:work_ui/models/transaction.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructors();

  final String _tableName = 'transactions';

  DatabaseService._constructors();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'amal_db.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            money TEXT NOT NULL,
            remark TEXT NOT NULL,
            type TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> addTransaction(Transactions txn) async {
    final db = await database;
    await db.insert(_tableName, txn.toMap());
    print("Transaction saved: ${txn.toMap()}");
  }

  Future<List<Transactions>> getalltransaction() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    return result.map((map) => Transactions.fromMap(map)).toList();
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTransaction(Transactions txn) async {
    final db = await database;
    await db.update(
      _tableName,
      txn.toMap(),
      where: 'id = ?',
      whereArgs: [txn.id],
    );
  }
}
