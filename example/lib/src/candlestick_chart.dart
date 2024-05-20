// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mdcharts/mdcharts.dart';
import 'package:rxdart/rxdart.dart';

import 'scaffolds/setup_scaffold.dart';
import 'widgets/button.dart';
import 'widgets/color_list_tile.dart';
import 'widgets/dialog_list_tile.dart';
import 'widgets/number_list_tile.dart';

final _settings = BehaviorSubject<CandlestickChartSettings>.seeded(
    const CandlestickChartSettings());
final _style = BehaviorSubject<CandlestickChartStyle>.seeded(
    const CandlestickChartStyle());
final _data = BehaviorSubject<CandlestickChartData>.seeded(CandlestickChartData(
  data: {
    DateTime(2022, 7):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 02):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 03):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 04):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 05):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 06):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 07):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 08):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 09):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 10):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 11):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 12):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 13):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 14):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 15):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 16):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 17):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 18):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 19):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 20):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 21):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 22):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 23):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 24):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 25):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 26):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 27):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 28):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 29):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 30):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 31):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
  },
));

class CandlestickChartExample extends StatelessWidget {
  const CandlestickChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupScaffold(
      body: _Chart(),
      setupChildren: [
        _GeneralDataSetupGroup(),
        SetupDivider(),
        _GeneralSettingsSetupGroup(),
        SetupDivider(),
        _YAxisLayoutSetupGroup(),
        SetupDivider(),
        _AxisDivisionsEdgesSetupGroup(),
        SetupDivider(),
        _GridStyleSetupGroup(),
        SetupDivider(),
        _AxisStyleSetupGroup(),
        SetupDivider(),
        _CandleStickStyleSetupGroup(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        return StreamBuilder<CandlestickChartStyle>(
          stream: _style,
          initialData: _style.value,
          builder: (context, style) {
            return StreamBuilder<CandlestickChartData>(
              stream: _data,
              initialData: _data.value,
              builder: (context, data) {
                return CandlestickChart(
                  settings: settings.requireData,
                  style: style.requireData,
                  data: data.requireData,
                );
              },
            );
          },
        );
      },
    );
  }
}

class _GeneralDataSetupGroup extends StatelessWidget {
  const _GeneralDataSetupGroup();

  static const _maxValue = 1000;

  CandlestickData _generateData({required bool positive}) {
    final low = positive
        ? Random().nextInt(_maxValue).toDouble()
        : -Random().nextInt(_maxValue).toDouble();
    final highBias = Random().nextInt(_maxValue).toDouble();
    final maxBidAskBias = highBias.abs().round();
    final bidBias = Random().nextInt(maxBidAskBias).toDouble();
    final askBias = Random().nextInt(maxBidAskBias).toDouble();

    return CandlestickData(
      low: low,
      high: low + highBias,
      bid: low + bidBias,
      ask: low + askBias,
    );
  }

  Map<DateTime, CandlestickData> getRandomizedData({required bool positive}) {
    final year = DateTime.now().year;
    final month = Random().nextInt(12) + 1;
    final days = Random().nextInt(20) + 8;
    final randomizedData = <DateTime, CandlestickData>{};
    for (var i = 1; i < days; i++) {
      randomizedData[DateTime(year, month, i)] =
          _generateData(positive: positive);
    }

    return randomizedData;
  }

  Map<DateTime, CandlestickData> getMixedRandomizedData() {
    final year = DateTime.now().year;
    final month = Random().nextInt(12) + 1;
    final days = Random().nextInt(5) * 4 + 8;
    final randomizedData = <DateTime, CandlestickData>{};

    for (var i = 1; i <= days / 4; i++) {
      randomizedData[DateTime(year, month, i)] = _generateData(positive: false);
    }
    for (var i = 1; i <= days / 4; i++) {
      randomizedData[DateTime(year, month, i + days ~/ 4)] =
          _generateData(positive: false);
    }
    for (var i = 1; i <= days / 4; i++) {
      randomizedData[DateTime(year, month, i + (days * 2) ~/ 4)] =
          _generateData(positive: true);
    }
    for (var i = 1; i <= days / 4; i++) {
      randomizedData[DateTime(year, month, i + (days * 3) ~/ 4)] =
          _generateData(positive: true);
    }

    return randomizedData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: 'General Data',
          children: [
            Button(
              onPressed: () {
                final randomizedData = getRandomizedData(positive: true);
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize with Positive Data'),
            ),
            Button(
              onPressed: () {
                final randomizedData = getRandomizedData(positive: false);
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize with Negative Data'),
            ),
            Button(
              onPressed: () {
                final randomizedData = getMixedRandomizedData();
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize with Mixed Data'),
            ),
            DialogListTile(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              value: data.requireData.predefinedMaxValue?.toString(),
              onChanged: (value) {
                if (value == null) {
                  _data.add(data.requireData.copyWith(
                    allowNullPredefinedMaxValue: true,
                    predefinedMaxValue: null,
                  ));
                  return;
                }

                final doubleValue = double.tryParse(value);
                _data.add(
                    data.requireData.copyWith(predefinedMaxValue: doubleValue));
              },
              title: const Text('predefinedMaxValue'),
            ),
          ],
        );
      },
    );
  }
}

class _GeneralSettingsSetupGroup extends StatelessWidget {
  const _GeneralSettingsSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'General Settings',
          children: [
            IntListTile(
              value: data.xAxisDivisions,
              onChanged: (value) =>
                  _settings.add(data.copyWith(xAxisDivisions: value)),
              title: const Text('xAxisDivisions'),
            ),
            IntListTile(
              value: data.yAxisDivisions,
              onChanged: (value) =>
                  _settings.add(data.copyWith(yAxisDivisions: value)),
              title: const Text('yAxisDivisions'),
            ),
            DialogListTile(
              value: data.xAxisLabelQuantity?.toString(),
              onChanged: (value) => _settings.add(data.copyWith(
                allowNullXAxisLabelQuantity: true,
                xAxisLabelQuantity: value != null ? int.parse(value) : null,
              )),
              keyboardType: TextInputType.number,
              title: const Text('xAxisLabelQuantity'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisX,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisX: value == true)),
              title: const Text('showAxisX'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisXSelectedLabelIfConcealed,
              onChanged: (value) => _settings.add(data.copyWith(
                  showAxisXSelectedLabelIfConcealed: value == true)),
              title: const Text('showAxisXSelectedLabelIfConcealed'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisY,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisY: value == true)),
              title: const Text('showAxisY'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisXLabels,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisXLabels: value == true)),
              title: const Text('showAxisXLabels'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisYLabels,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisYLabels: value == true)),
              title: const Text('showAxisYLabels'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisXLabelSelection,
              onChanged: (value) => _settings
                  .add(data.copyWith(showAxisXLabelSelection: value == true)),
              title: const Text('showAxisXLabelSelection'),
            ),
            IntListTile(
              value: data.yAxisLabelSpacing.toInt(),
              onChanged: (value) {
                final doubleValue = value.toDouble();
                _settings.add(data.copyWith(yAxisLabelSpacing: doubleValue));
              },
              title: const Text('yAxisLabelSpacing'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.selectionEnabled,
              onChanged: (value) =>
                  _settings.add(data.copyWith(selectionEnabled: value == true)),
              title: const Text('selectionEnabled'),
            ),
          ],
        );
      },
    );
  }
}

class _YAxisLayoutSetupGroup extends StatelessWidget {
  const _YAxisLayoutSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Y Axis Layout',
          children: [
            for (var i = 0; i < YAxisLayout.values.length; i++)
              RadioListTile<YAxisLayout>(
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: data.yAxisLayout,
                value: YAxisLayout.values[i],
                onChanged: (value) =>
                    _settings.add(data.copyWith(yAxisLayout: value)),
                title: Text(YAxisLayout.values[i].name),
              ),
          ],
        );
      },
    );
  }
}

class _AxisDivisionsEdgesSetupGroup extends StatelessWidget {
  const _AxisDivisionsEdgesSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Axis Division Edges',
          children: [
            for (var i = 0; i < AxisDivisionEdges.values.length; i++)
              RadioListTile<AxisDivisionEdges>(
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: data.axisDivisionEdges,
                value: AxisDivisionEdges.values[i],
                onChanged: (value) =>
                    _settings.add(data.copyWith(axisDivisionEdges: value)),
                title: Text(AxisDivisionEdges.values[i].name),
              ),
          ],
        );
      },
    );
  }
}

class _GridStyleSetupGroup extends StatelessWidget {
  const _GridStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Grid Style',
          children: [
            IntListTile(
              value: data.gridStyle.xAxisStroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    gridStyle: data.gridStyle.copyWith(
                      xAxisStroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('xAxisStroke'),
            ),
            IntListTile(
              value: data.gridStyle.yAxisStroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    gridStyle: data.gridStyle.copyWith(
                      yAxisStroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('yAxisStroke'),
            ),
            ColorListTile(
              value: data.gridStyle.xAxisColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    gridStyle: data.gridStyle.copyWith(
                      xAxisColor: value,
                    ),
                  ),
                );
              },
              title: const Text('xAxisColor'),
            ),
            ColorListTile(
              value: data.gridStyle.yAxisColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    gridStyle: data.gridStyle.copyWith(
                      yAxisColor: value,
                    ),
                  ),
                );
              },
              title: const Text('yAxisColor'),
            ),
          ],
        );
      },
    );
  }
}

class _AxisStyleSetupGroup extends StatelessWidget {
  const _AxisStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Axis Style',
          children: [
            ColorListTile(
              value: data.axisStyle.color,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    axisStyle: data.axisStyle.copyWith(
                      color: value,
                    ),
                  ),
                );
              },
              title: const Text('color'),
            ),
            ColorListTile(
              value: data.axisStyle.xAxisSelectedLabelBackgroundColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    axisStyle: data.axisStyle.copyWith(
                      xAxisSelectedLabelBackgroundColor: value,
                    ),
                  ),
                );
              },
              title: const Text('xAxisSelectedLabelBackgroundColor'),
            ),
            IntListTile(
              value: data.axisStyle.stroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    axisStyle: data.axisStyle.copyWith(
                      stroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('stroke'),
            ),
            IntListTile(
              value: data.axisStyle.xAxisLabelTopMargin.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    axisStyle: data.axisStyle.copyWith(
                      xAxisLabelTopMargin: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('xAxisLabelTopMargin'),
            ),
            IntListTile(
              value: data.axisStyle.xAxisSelectedLabelBorderRadius.topLeft.x
                  .toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    axisStyle: data.axisStyle.copyWith(
                      xAxisSelectedLabelBorderRadius: BorderRadius.all(
                        Radius.circular(value.toDouble()),
                      ),
                    ),
                  ),
                );
              },
              title: const Text('xAxisSelectedLabelBorderRadius'),
            ),
          ],
        );
      },
    );
  }
}

class _CandleStickStyleSetupGroup extends StatelessWidget {
  const _CandleStickStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Candle Stick Style',
          children: [
            ColorListTile(
              value: data.candleStickStyle.bullishColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    candleStickStyle: data.candleStickStyle.copyWith(
                      bullishColor: value,
                    ),
                  ),
                );
              },
              title: const Text('bullishColor'),
            ),
            ColorListTile(
              value: data.candleStickStyle.bearishColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    candleStickStyle: data.candleStickStyle.copyWith(
                      bearishColor: value,
                    ),
                  ),
                );
              },
              title: const Text('bearishColor'),
            ),
            IntListTile(
              value: data.candleStickStyle.stickStroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    candleStickStyle: data.candleStickStyle.copyWith(
                      stickStroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('stickStroke'),
            ),
            IntListTile(
              value: data.candleStickStyle.candleStroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    candleStickStyle: data.candleStickStyle.copyWith(
                      candleStroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('candleStroke'),
            ),
          ],
        );
      },
    );
  }
}
