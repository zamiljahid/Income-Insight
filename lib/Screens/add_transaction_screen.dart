import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({Key? key}) : super(key: key);

  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _reasonController = TextEditingController();
  String _transactionType = 'Income';
  int selectedOption = 1;
  DateTime _selectedDate = DateTime.now();
  double _amount = 0.0;
  bool _isAddingTransaction = false;
  String? empName;

  @override
  void initState() {
    load();
    super.initState();
  }

  load() async {
    SharedPreferences perfs = await SharedPreferences.getInstance();
    String? emp_name = perfs.getString('emp_name');

    if (emp_name != null) {
      setState(() {
        empName = emp_name.toString();
      });
    }
    setState(() {});
  }

  Future<void> _addTransaction() async {
    if (_reasonController.text.isEmpty || _amount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(
                'All fields are required. Please fill in all the details.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    setState(() {
      _isAddingTransaction = true;
    });

    const url =
        'https://script.google.com/macros/s/AKfycbw-eoNzVfCbCodk5wAlMMJ7MljwpGEnyw7auI7uNzn_sWa1SYUOTLL6v8j-p9axmn-q/exec';

    await http.post(
      Uri.parse(url),
      body: {
        'action': 'insertTransaction',
        'name': empName.toString(),
        'date': DateFormat('yyyy-MM-dd').format(_selectedDate),
        'time': DateFormat('HH:mm').format(_selectedDate),
        'type': _transactionType,
        'reason': _reasonController.text,
        'amount': _amount.toString(),
      },
    );

    setState(() {
      _isAddingTransaction = false;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Database is updated'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text('A D D  T R A N S A C T I O N'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today),
                  SizedBox(width: 8),
                  Text(
                    DateFormat('yyyy-MM-dd').format(_selectedDate),
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ListTile(
                title: const Text('Income'),
                leading: Radio(
                  activeColor: Colors.green,
                  value: 1,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                      _transactionType = 'Income';
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Expense'),
                leading: Radio(
                  activeColor: Colors.green,
                  value: 2,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value!;
                      _transactionType = 'Expense';
                    });
                  },
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: Colors.black),
                controller: _reasonController,
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  filled: true,
                  fillColor: Colors.lightGreenAccent,
                  icon: Icon(
                    Icons.description,
                    size: 35,
                    color: Colors.green,
                  ),
                  labelText: 'Reason',
                  labelStyle: TextStyle(color: Colors.black87),
                ),
              ),
              SizedBox(height: 22),
              TextFormField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _amount = double.tryParse(value) ?? 0.0;
                  });
                },
                textInputAction: TextInputAction.next,
                style: const TextStyle(color: Colors.black),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  errorText:
                      _amount <= 0 ? 'Please enter a valid amount' : null,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  filled: true,
                  fillColor: Colors.lightGreenAccent,
                  icon: const Icon(
                    Icons.money,
                    size: 35,
                    color: Colors.green,
                  ),
                  labelStyle: TextStyle(color: Colors.black87),
                ),
                validator: (value) {
                  return value!.isEmpty ? 'Field cannot be empty' : null;
                },
              ),
              const SizedBox(height: 24),
              _isAddingTransaction
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                        onPressed: () {
                          _addTransaction();
                        },
                        child: const Text('Add Transaction', style: TextStyle(color: Colors.white),),
                      ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
