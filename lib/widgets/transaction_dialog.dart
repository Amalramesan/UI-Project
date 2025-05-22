import 'package:flutter/material.dart';
import 'package:work_ui/services/database_servises.dart';
import '../models/transaction.dart';

Future<Transactions?> showAddDialog(BuildContext context, String email) {
  final TextEditingController moneyController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  String transactionType = 'debit';
  final List<String> types = ['debit', 'credit'];

  return showDialog<Transactions>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close),
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: transactionType,
                items: types.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => transactionType = value!,
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: moneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Money',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final txn = Transactions(
                        money: moneyController.text,
                        remark: remarkController.text,
                        type: transactionType,
                      );
                      Navigator.of(context).pop(txn);
                    },
                    child: Text('Submit'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showEditDialog(
  BuildContext context,
  Transactions txn,
  Function(Transactions) onUpdate,
) {
  final moneyController = TextEditingController(text: txn.money);
  final remarkController = TextEditingController(text: txn.remark);
  String transactionType = txn.type;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Transaction",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: transactionType,
                items: ['debit', 'credit'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) => transactionType = value!,
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: moneyController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Money',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: remarkController,
                decoration: InputDecoration(
                  labelText: 'Remark',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final updatedTxn = Transactions(
                    id: txn.id,
                    money: moneyController.text,
                    remark: remarkController.text,
                    type: transactionType,
                  );
                  await DatabaseService.instance.updateTransaction(updatedTxn);
                  onUpdate(updatedTxn);
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      );
    },
  );
}
