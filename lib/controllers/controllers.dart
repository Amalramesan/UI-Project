import 'package:flutter/material.dart';
import 'package:work_ui/models/transaction.dart';
import 'package:work_ui/services/database_servises.dart';

class TransactionController with ChangeNotifier {
  final List<Transactions> _transactions = [];
  bool _isLoading = false;

  List<Transactions> get transactions => _transactions;
  bool get isLoading => _isLoading;

  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    final data = await DatabaseService.instance.getalltransaction();
    _transactions
      ..clear()
      ..addAll(data);

    _isLoading = false;
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
    _transactions.clear();
    notifyListeners();
  }
}
