import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/models/transaction.dart';
import 'package:work_ui/pages/login_page.dart';
import 'package:work_ui/services/database_servises.dart';
import 'package:work_ui/widgets/transaction_dialog.dart';
import 'package:work_ui/widgets/transaction_list.dart';

class Homepage extends StatefulWidget {
  final String email;
  const Homepage({super.key, required this.email});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final ValueNotifier<List<Transactions>> transactions = ValueNotifier([]);

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    transactions.value = [];
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseService.instance.getalltransaction();
    transactions.value = data;
  }

  @override
  void dispose() {
    transactions.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadTransactions(), // Load transactions once
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Welcome ${widget.email}'),
            actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
          ),
          body: ValueListenableBuilder<List<Transactions>>(
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
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final txn = await showAddDialog(context, widget.email);
              if (txn != null) {
                await DatabaseService.instance.addTransaction(txn);
                await _loadTransactions();
              }
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
