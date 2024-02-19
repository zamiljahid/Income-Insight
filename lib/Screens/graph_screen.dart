import 'package:flutter/material.dart';
import 'package:flutter_echart/flutter_echart.dart';
import 'package:income_insight/wrapper.dart';

import '../Model classes/last_row_data_model.dart';
import '../api_helper.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  Future<LastRowData>? _lastRowData;

  @override
  void initState() {
    super.initState();
    _lastRowData = ApiHelper.getLastRowData();
  }

  @override
  Widget build(BuildContext context) {
    return Wrapper(
      child: Scaffold(
        appBar: AppBar(
          title: Text('G R A P H'),
          centerTitle: true,
        ),
        body: Center(
          child: FutureBuilder<LastRowData>(
            future: _lastRowData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: MediaQuery.of(context).size.height - 120,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 6,
                      color: Colors.lightGreenAccent,
                      backgroundColor: Colors.green,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.hasData) {
                LastRowData lastRowData = snapshot.data!;
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 2.8,
                    width: MediaQuery.of(context).size.width,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: PieChatWidget(
                          dataList: [
                            EChartPieBean(
                              title: "Income",
                              number: lastRowData.totalIncome,
                              color: Colors.lightGreen,
                            ),
                            EChartPieBean(
                              title: "Expense",
                              number: lastRowData.totalExpense,
                              color: Colors.green,
                            ),
                          ],
                          isLog: false,
                          isBackground: true,
                          isLineText: true,
                          bgColor: Colors.white,
                          isFrontgText: true,
                          initSelect: 1,
                          openType: OpenType.ANI,
                          loopType: LoopType.AUTO_LOOP,
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height - 120,
                  child: const Center(
                    child: Text('No Data'),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

