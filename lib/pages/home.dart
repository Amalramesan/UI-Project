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
  List<Transactions> transactions = [];

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  Future<void> _loadTransactions() async {
    final data = await DatabaseService.instance.getalltransaction();
    transactions = data; // No setState here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${widget.email}'),
        actions: [IconButton(icon: Icon(Icons.logout), onPressed: _logout)],
      ),
      body: FutureBuilder(
        future: _loadTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return DefaultTabController(
            length: 2,
            child: Column(
              children: [
                TabBar(
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
                        transactions: transactions,
                        refresh: () async {
                          await _loadTransactions();
                          setState(() {}); // Refresh list manually
                        },
                      ),
                      TransactionList(
                        type: 'credit',
                        transactions: transactions,
                        refresh: () async {
                          await _loadTransactions();
                          setState(() {}); // Refresh list manually
                        },
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
          final txn = await showAddDialog(context);
          if (txn != null) {
            await DatabaseService.instance.addTransaction(txn);
            await _loadTransactions();
            setState(() {}); // Refresh list after adding
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
