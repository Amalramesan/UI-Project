import 'package:flutter/material.dart';
import 'package:work_ui/services/database_servises.dart';
import '../models/transaction.dart';
import 'transaction_dialog.dart';

class TransactionList extends StatelessWidget {
  final List<Transactions> transactions;
  final String type;
  final Function() refresh;

  const TransactionList({
    super.key,
    required this.transactions,
    required this.type,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    final filteredList = transactions.where((t) => t.type == type).toList();
    return ListView.builder(
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final item = filteredList[index];
        return ListTile(
          leading: Icon(
            Icons.circle,
            color: type == 'debit' ? Colors.red : Colors.green,
          ),
          title: Text("Money: ${item.money}"),
          subtitle: Text(item.remark),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showEditDialog(context, item, (_) => refresh());
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () async {
                  await DatabaseService.instance.deleteTransaction(item.id!);
                  refresh();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
