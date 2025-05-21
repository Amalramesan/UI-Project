import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_ui/pages/login_page.dart';
import 'package:work_ui/services/database_servises.dart';

class Homepage extends StatefulWidget {
  final String email;
  const Homepage({super.key, required this.email});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Loginn()),
    );
  }

  final DatabaseService dbService = DatabaseService.instance;
  bool _isDataLoaded = false;
  List<Transaction> transactionss = [];
  @override
  Widget build(BuildContext context) {
    if (!_isDataLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final data = await loadTransaction();
        setState(() {
          transactionss = data;
          _isDataLoaded = true;
        });
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.email,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _logout();
            },
            icon: Icon(Icons.logout, color: Colors.black),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              color: Colors.grey[300],
              child: TabBar(
                labelColor: Colors.blueAccent,
                unselectedLabelColor: Colors.black,
                indicatorColor: Colors.blueAccent,
                labelStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                unselectedLabelStyle: TextStyle(fontSize: 18),
                tabs: [
                  Tab(text: 'Debit'),
                  Tab(text: 'Credit'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Debit Tab
                  Builder(
                    builder: (context) {
                      final debitList = transactionss
                          .where((t) => t.type == 'debit')
                          .toList();
                      return ListView.builder(
                        itemCount: debitList.length,
                        itemBuilder: (context, index) {
                          final item = debitList[index];
                          return ListTile(
                            leading: Icon(Icons.circle, color: Colors.red),
                            title: Text("money: ${item.money}"),
                            subtitle: Text(item.remark),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showEditDialog(context, item, (
                                      updatedTxn,
                                    ) async {
                                      final updatedList =
                                          await loadTransaction();
                                      setState(() {
                                        transactionss = updatedList;
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                ),

                                IconButton(
                                  onPressed: () async {
                                    await DatabaseService.instance
                                        .deleteTransaction(item.id!);
                                    final updatedata = await loadTransaction();
                                    setState(() {
                                      transactionss = updatedata;
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),

                  // Credit Tab
                  Builder(
                    builder: (context) {
                      final creditList = transactionss
                          .where((t) => t.type == 'credit')
                          .toList();
                      return ListView.builder(
                        itemCount: creditList.length,
                        itemBuilder: (context, index) {
                          final item = creditList[index];
                          return ListTile(
                            leading: Icon(Icons.circle, color: Colors.green),
                            title: Text("money: ${item.money}"),
                            subtitle: Text(item.remark),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    showEditDialog(context, item, (
                                      updatedTxn,
                                    ) async {
                                      final updatedList =
                                          await loadTransaction();
                                      setState(() {
                                        transactionss = updatedList;
                                      });
                                    });
                                  },
                                  icon: Icon(Icons.edit),
                                ),

                                IconButton(
                                  onPressed: () async {
                                    await DatabaseService.instance
                                        .deleteTransaction(item.id!);
                                    final updatedata = await loadTransaction();
                                    setState(() {
                                      transactionss = updatedata;
                                    });
                                  },
                                  icon: Icon(Icons.delete),
                                ),
                              ],
                            ),
                          );
                        },
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
          final newTransaction = await showdialogbox(context);

          if (newTransaction != null && newTransaction is Transaction) {
            await DatabaseService.instance.addTransaction(newTransaction);
            final data = await loadTransaction();
            setState(() {
              transactionss = data;
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<List<Transaction>> loadTransaction() async {
  final data = await DatabaseService.instance.getalltransaction();

  return data;
}

Future<Transaction?> showdialogbox(BuildContext context) {
  final TextEditingController moneycontroller = TextEditingController();
  final TextEditingController remarkcontroller = TextEditingController();
  String? transactiontypes = 'debit';
  final List<String> types = ['debit', 'credit'];
  return showDialog<Transaction>(
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
              //drope dowm
              DropdownButtonFormField<String>(
                value: transactiontypes,
                items: types.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  transactiontypes = value!;
                },
                decoration: InputDecoration(
                  labelText: 'Transaction Type',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Money
              TextField(
                controller: moneycontroller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Money',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              // Remark
              TextField(
                controller: remarkcontroller,
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
                    onPressed: () async {
                      Transaction item = Transaction(
                        money: moneycontroller.text,
                        remark: remarkcontroller.text,
                        type: transactiontypes!,
                      );
                      Navigator.of(context).pop(item);
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
  Transaction txn,
  Function(Transaction) onUpdate,
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
                onChanged: (value) {
                  transactionType = value!;
                },
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
                  final updatedTxn = Transaction(
                    id: txn.id,
                    money: moneyController.text,
                    remark: remarkController.text,
                    type: transactionType,
                  );

                  await DatabaseService.instance.updateTransaction(updatedTxn);
                  onUpdate(updatedTxn); // <-- important
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
