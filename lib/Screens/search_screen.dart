import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Transaction {
  final String name;
  final String date;
  final int amount;
  final String type;
  final String reason;

  Transaction({
    required this.name,
    required this.date,
    required this.amount,
    required this.type,
    required this.reason,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      name: json['name'],
      date: json['date'],
      amount: json['amount'],
      type: json['type'],
      reason: json['reason'],
    );
  }
}

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController? _searchController;
  String? _searchOption;
  Future<List<Transaction>>? _searchResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchOption = 'name'; // Default search option
  }

  Future<List<Transaction>> _searchTransactions(String query) async {
    String endpoint;
    if (_searchOption == 'name') {
      endpoint = 'getTransactionsByName';
    } else if (_searchOption == 'date') {
      endpoint = 'getTransactionsByDate';
    } else {
      throw Exception('Invalid search option');
    }

    final response = await http.get(
      Uri.parse('https://script.google.com/macros/s/AKfycbyiuFYnrwe93C5fGWEwuFgGGnCloS2_j8KEJv983_7L0le44plfFj15Zsb_2UzNrci-/exec?action=$endpoint&$_searchOption=$query'),
    );

    print(response.body);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Transaction.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Transactions'),
        centerTitle: true,
      ),
      body: Center(child: Text('COMING SOON'))

      // Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     children: [
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Radio(
      //             value: 'name',
      //             groupValue: _searchOption,
      //             onChanged: (value) {
      //               setState(() {
      //                 _searchOption = 'name';
      //               });
      //             },
      //           ),
      //           Text('Search by Name'),
      //           SizedBox(width: 20),
      //           Radio(
      //             value: 'date',
      //             groupValue: _searchOption,
      //             onChanged: (value) {
      //               setState(() {
      //                 _searchOption = 'date';
      //               });
      //             },
      //           ),
      //           Text('Search by Date'),
      //         ],
      //       ),
      //       TextField(
      //         controller: _searchController,
      //         decoration: InputDecoration(
      //           labelText: _searchOption == 'name' ? 'Enter Name' : 'Enter Date (YYYY-MM-DD)',
      //         ),
      //       ),
      //       const SizedBox(height: 20),
      //       ElevatedButton(
      //         onPressed: () {
      //           setState(() {
      //             _isLoading = true;
      //             _searchResults = _searchTransactions(_searchController!.text);
      //           });
      //         },
      //         child: Text('Search'),
      //       ),
      //       SizedBox(height: 20),
      //       _isLoading
      //           ? const CircularProgressIndicator()
      //           : Expanded(
      //         child: FutureBuilder<List<Transaction>>(
      //           future: _searchResults,
      //           builder: (context, snapshot) {
      //             if (snapshot.connectionState == ConnectionState.waiting) {
      //               return CircularProgressIndicator();
      //             } else if (snapshot.hasError) {
      //               return Text('Error: ${snapshot.error}');
      //             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //               return Text('No results found.');
      //             } else {
      //               List<Transaction> transactions = snapshot.data!;
      //               _isLoading = false;
      //               return Expanded(
      //                 child: ListView.builder(
      //                   itemCount: transactions.length,
      //                   itemBuilder: (context, index) {
      //                     return Padding(
      //                       padding: const EdgeInsets.only(right: 10, left: 10),
      //                       child: Card(
      //                         color: Colors.grey[100],
      //                         child: ListTile(
      //                           title: Column(
      //                             crossAxisAlignment: CrossAxisAlignment.start,
      //                             children: [
      //                               Text('Reason: ${transactions[index].reason}'),
      //                               Text('Date: ${transactions[index].date}'),
      //                             ],
      //                           ),
      //                           trailing: Text(
      //                             '${transactions[index].type == 'Income' ? '+' : '-'}BDT ${transactions[index].amount.toStringAsFixed(2)}',
      //                             style: TextStyle(
      //                               color: transactions[index].type == 'Income'
      //                                   ? Colors.green
      //                                   : Colors.red,
      //                             ),
      //                           ),
      //                         ),
      //                       ),
      //                     );
      //                   },
      //                 ),
      //               );
      //             }
      //           },
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}

