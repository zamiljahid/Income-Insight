import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:income_insight/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../Model classes/last_row_data_model.dart';
import '../Model classes/transaction_model.dart';
import '../api_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<LastRowData>? _lastRowData;
  List<Transaction> transactions = [];
  String empName = "";
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    initSharedPreferences();
    load();
    _lastRowData = ApiHelper.getLastRowData();
  }

  load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emp_name = prefs.getString('emp_name');

    if (emp_name != null) {
      setState(() {
        empName = emp_name;
        loadTransactions(empName);
      });
    }
  }

  void loadTransactions(String name) async {
    try {
      List<Transaction> result = await ApiHelper.getTransactionsByName(name);
      setState(() {
        transactions = result;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error: $e');
      }
      // Handle error as needed
    }
  }

  Future<void> initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? emp_name = prefs.getString('emp_name');

    if (emp_name != null) {
      setState(() {
        empName = emp_name;
      });
    }
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    loadTransactions(empName);
    _lastRowData = ApiHelper.getLastRowData();
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('B A L A N C E'),
          centerTitle: true,
        ),
        body: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          header: const WaterDropHeader(
            waterDropColor: Colors.green,
          ),
          // color:  Colors.green,
          // backgroundColor: Colors.lightGreenAccent,
          onRefresh: _refreshData,
          controller: _refreshController,
          child: FutureBuilder<LastRowData>(
            future: _lastRowData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 6,
                    color: Colors.lightGreenAccent,
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                LastRowData lastRowData = snapshot.data!;
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.green,
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.green,
                                  offset: Offset(4.0, 4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0),
                              BoxShadow(
                                  color: Colors.white,
                                  offset: Offset(-4.0, -4.0),
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0),
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(lastRowData.monthYear,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              Text(
                                'BDT ${lastRowData.currentBalance}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 40),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_upward,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Income',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'BDT ${lastRowData.totalIncome}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_downward,
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text('Expense',
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                'BDT ${lastRowData.totalExpense}',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Transaction History',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          transactions.isEmpty
                              ? const Center(
                                  child: Text('Transaction history is empty'))
                              : FutureBuilder<List<Transaction>>(
                                  future:
                                      ApiHelper.getTransactionsByName(empName),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // Show a loading widget while data is being fetched
                                      return const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.green,
                                        backgroundColor:
                                            Colors.lightGreenAccent,
                                      ));
                                    } else if (snapshot.hasError) {
                                      // Handle error case
                                      return Center(
                                          child:
                                              Text('Error: ${snapshot.error}'));
                                    } else if (!snapshot.hasData ||
                                        snapshot.data!.isEmpty) {
                                      // No transactions
                                      return const Center(
                                          child: Text(
                                              'Transaction history is empty'));
                                    } else {
                                      // Display transactions
                                      List<Transaction> transactions =
                                          snapshot.data!;
                                      return Expanded(
                                        child: ListView.builder(
                                          itemCount: transactions.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, left: 10),
                                              child: Card(
                                                color: Colors.grey[100],
                                                child: ListTile(
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'Reason: ${transactions[index].reason}'),
                                                      Text(
                                                        'Date: ${transactions[index].date}',
                                                      ),
                                                    ],
                                                  ),
                                                  trailing: Text(
                                                    '${transactions[index].type == 'Income' ? '+' : '-'}BDT ${transactions[index].amount.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                      color: transactions[index]
                                                                  .type ==
                                                              'Income'
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  },
                                ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text('No Data'));
              }
            },
          ),
        ),
      ),
    );
  }
}
