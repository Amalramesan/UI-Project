import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/controllers/controllers.dart';
import 'package:work_ui/pages/login_page.dart';
import 'package:work_ui/widgets/transaction_dialog.dart';
import 'package:work_ui/widgets/transaction_list.dart';

class Homepage extends StatelessWidget {
  final String email;

  Homepage({super.key, required this.email});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Provider.of<TransactionController>(
      context,
      listen: false,
    ).clearTransactions();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();

    // Load transactions only once after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isLoading && controller.transactions.isEmpty) {
        controller.loadTransactions();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Consumer<TransactionController>(
        builder: (context, controller, child) {
          return controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : DefaultTabController(
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
                              transactions: controller.transactions,
                              refresh: controller.loadTransactions,
                            ),
                            TransactionList(
                              type: 'credit',
                              transactions: controller.transactions,
                              refresh: controller.loadTransactions,
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
          final txn = await showAddDialog(context, email);
          if (txn != null) {
            await controller.addTransaction(txn);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
