// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mdcharts/mdcharts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MDCharts Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF418FDE), Color(0xFF00468C)],
          ),
        ),
        child: _Grid(
          rows: 2,
          columns: 2,
          children: [
            LineChart(
              settings: const LineChartSettings.gridless(),
              style: LineChartStyle(
                limitStyle: LineChartLimitStyle(
                  labelStyle: LineChartLimitStyle.defaultStyle.copyWith(
                    fontSize: 20,
                  ),
                  labelOveruseStyle: LineChartLimitStyle.defaultStyle.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              data: LineChartData(
                gridType: LineChartGridType.undefined,
                limit: 50,
                limitText: 'Custom label text',
                data: {
                  DateTime(2022, 03, 2): 10,
                  DateTime(2022, 03, 4): 15,
                  DateTime(2022, 03, 5): 29,
                  DateTime(2022, 03, 20): 83,
                },
              ),
            ),
            LineChart(
              data: LineChartData(
                gridType: LineChartGridType.monthly,
                dataType: LineChartDataType.bidirectional,
                limit: 90,
                limitText: '90 ₴',
                data: {
                  DateTime(2022, 03, 2): 10,
                  DateTime(2022, 03, 4): 15,
                  DateTime(2022, 03, 5): 29,
                  DateTime(2022, 03, 20): 83,
                },
              ),
              style: const LineChartStyle(
                lineStyle: LineChartLineStyle(
                  fillColor: Colors.white24,
                  fillGradient: null,
                ),
              ),
            ),
            LineChart(
              settings: const LineChartSettings.gridless(),
              data: LineChartData(
                gridType: LineChartGridType.monthly,
                dataType: LineChartDataType.unidirectional,
                limit: 80,
                data: {
                  DateTime(2022, 03, 1): 10,
                  DateTime(2022, 03, 2): 15,
                  DateTime(2022, 03, 3): 18,
                  DateTime(2022, 03, 5): 21,
                  DateTime(2022, 03, 7): 28,
                  DateTime(2022, 03, 11): 33,
                  DateTime(2022, 03, 16): 38,
                  DateTime(2022, 03, 20): 83,
                },
              ),
            ),
            LineChart(
              settings: const LineChartSettings.gridless(),
              data: LineChartData(
                gridType: LineChartGridType.monthly,
                dataType: LineChartDataType.unidirectional,
                data: {
                  DateTime(2022, 03, 2): 83,
                  DateTime(2022, 03, 4): 76,
                  DateTime(2022, 03, 6): 65,
                  DateTime(2022, 03, 9): 29,
                  DateTime(2022, 03, 11): 15,
                  DateTime(2022, 03, 20): 10,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    Key? key,
    required this.rows,
    required this.columns,
    required this.children,
  }) : super(key: key);

  final int rows;
  final int columns;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < rows; i++)
          Expanded(
            child: Row(
              children: [
                for (var j = 0; j < columns; j++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: children[i + j + (i > 0 ? 1 : 0)],
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
