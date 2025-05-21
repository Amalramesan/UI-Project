//create a class for managing database
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Transaction {
  final int? id;
  final String type;
  final String money;
  final String remark;
  Transaction({
    this.id,
    required this.money,
    required this.remark,
    required this.type,
  });
  Map<String, dynamic> toMap() {
    return {'id': id, 'money': money, 'remark': remark, 'type': type};
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      money: map['money'],
      remark: map['remark'],
      type: map['type'],
    );
  }
}

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

  Future<void> addTransaction(Transaction txn) async {
    final db = await database;
    await db.insert(_tableName, txn.toMap());
    print("Transaction saved: ${txn.toMap()}");
  }

  Future<List<Transaction>> getalltransaction() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(_tableName);
    return result.map((map) => Transaction.fromMap(map)).toList();
  }

  Future<void> deleteTransaction(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateTransaction(Transaction txn) async {
    final db = await database;
    await db.update(
      _tableName,
      txn.toMap(),
      where: 'id = ?',
      whereArgs: [txn.id],
    );
  }
}
