// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import 'src/bar_chart.dart';
import 'src/candlestick_chart.dart';
import 'src/donut_chart.dart';
import 'src/gauge_chart.dart';
import 'src/line_chart.dart';
import 'src/scaffolds/example_scaffold.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExampleScaffold(
      tabs: {
        'Line Chart': LineChartExample(),
        'Bar Chart': BarChartExample(),
        'Gauge Chart': GaugeChartExample(),
        'Donut Chart': DonutChartExample(),
        'Candlestick Chart': CandlestickChartExample(),
      },
    );
  }
}
