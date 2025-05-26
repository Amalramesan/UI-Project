import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:work_ui/controllers/controllers.dart';
import 'package:work_ui/controllers/login_controller.dart';
import 'package:work_ui/pages/login_page.dart';
import 'package:work_ui/untils/shared_prefs.dart';
import 'package:work_ui/widgets/transaction_dialog.dart';
import 'package:work_ui/widgets/transaction_list.dart';

class Homepage extends StatelessWidget {
  final String email;

  const Homepage({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $email'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await SharedPrefs.clearlogin();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: DefaultTabController(
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
                  Consumer<TransactionController>(
                    builder: (context, controller, _) {
                      return TransactionList(
                        type: 'debit',
                        transactions: controller.transactions,
                        refresh: controller.loadTransactions,
                      );
                    },
                  ),
                  Consumer<TransactionController>(
                    builder: (context, controller, _) {
                      return TransactionList(
                        type: 'credit',
                        transactions: controller.transactions,
                        refresh: controller.loadTransactions,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final txn = await showAddDialog(context, email);
          if (txn != null) {
            context.read<TransactionController>().addTransaction(txn);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
