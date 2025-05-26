import 'package:flutter/material.dart';
import 'package:work_ui/models/transaction.dart';
import 'package:work_ui/services/database_servises.dart';

class TransactionController with ChangeNotifier {
  final List<Transactions> _transactions = [];

  List<Transactions> get transactions => _transactions;

  Future<void> loadTransactions() async {
    final data = await DatabaseService.instance.getalltransaction();
    _transactions
      ..clear()
      ..addAll(data);

    notifyListeners();
  }

  Future<void> addTransaction(Transactions txn) async {
    await DatabaseService.instance.addTransaction(txn);
    await loadTransactions();
  }

  Future<void> updateTransaction(Transactions txn) async {
    await DatabaseService.instance.updateTransaction(txn);
    await loadTransactions();
  }

  Future<void> deleteTransaction(int id) async {
    await DatabaseService.instance.deleteTransaction(id);
    await loadTransactions();
  }

  void clearTransactions() {
    notifyListeners();
  }
}
