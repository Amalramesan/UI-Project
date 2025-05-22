import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/models/transaction.dart';
import 'package:work_ui/pages/login_page.dart';
import 'package:work_ui/services/database_servises.dart';
import 'package:work_ui/widgets/transaction_dialog.dart';
import 'package:work_ui/widgets/transaction_list.dart';

class Homepage extends StatelessWidget {
  final String email;
  final ValueNotifier<List<Transactions>> transactions = ValueNotifier([]);
  final ValueNotifier<bool> isLoading = ValueNotifier(true);

  Homepage({super.key, required this.email});

  Future<void> _loadTransactions() async {
    isLoading.value = true;
    final data = await DatabaseService.instance.getalltransaction();
    transactions.value = data;
    isLoading.value = false;
  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    transactions.value = [];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Load data after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoading.value == true && transactions.value.isEmpty) {
        _loadTransactions();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome \n $email')
        
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, _) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ValueListenableBuilder<List<Transactions>>(
            valueListenable: transactions,
            builder: (context, txnList, _) {
              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Debit'),
                        Tab(text: 'Credit'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          TransactionList(
                            type: 'debit',
                            transactions: txnList,
                            refresh: _loadTransactions,
                          ),
                          TransactionList(
                            type: 'credit',
                            transactions: txnList,
                            refresh: _loadTransactions,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final txn = await showAddDialog(context, email);
          if (txn != null) {
            await DatabaseService.instance.addTransaction(txn);
            await _loadTransactions();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
