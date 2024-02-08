import 'dart:convert';

import 'package:intl/intl.dart';

import 'Model classes/last_row_data_model.dart';
import 'package:http/http.dart' as http;

import 'Model classes/transaction_model.dart';


class ApiHelper {
  static final String baseUrl = 'https://script.google.com/macros/s/AKfycbw-eoNzVfCbCodk5wAlMMJ7MljwpGEnyw7auI7uNzn_sWa1SYUOTLL6v8j-p9axmn-q/exec';

  static Future<LastRowData> getLastRowData() async {
    final response = await http.get(
        Uri.parse('$baseUrl?action=getLastRowData'));

    if (response.statusCode == 200) {
      print(response.body);

      final Map<String, dynamic> jsonData = json.decode(response.body);
      print(response.body);
      return LastRowData.fromJson(jsonData);
    } else {
      throw Exception('Failed to load last row data');
    }
  }

  static Future<List<Transaction>> getTransactionsByName(String name) async {
    final url = '$baseUrl?action=getTransactionsByName&name=$name';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print(response.body);

      return jsonData.map((data) {
        return Transaction(
          date: formatDate(data['date']),
          amount: data['amount'],
          type: data['type'],
          reason: data['reason'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load transactions');
    }
  }

  static String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }
}