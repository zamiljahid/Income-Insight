import 'package:intl/intl.dart';

class LastRowData {
  final String monthYear;
  final int currentBalance;
  final int totalIncome;
  final int totalExpense;

  LastRowData({
    required this.monthYear,
    required this.currentBalance,
    required this.totalIncome,
    required this.totalExpense,
  });


  factory LastRowData.fromJson(Map<String, dynamic> json) {
    String formattedDate = DateFormat('MMMM yyyy', 'en_US').format(
      DateTime.parse(json['monthYear']).add(Duration(days: 30)),
    );
    return LastRowData(
      monthYear: formattedDate,
      currentBalance: json['currentBalance'],
      totalIncome: json['totalIncome'],
      totalExpense: json['totalExpense'],
    );
  }
}
