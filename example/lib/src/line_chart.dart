// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mdcharts/mdcharts.dart';
import 'package:rxdart/rxdart.dart';

import 'scaffolds/setup_scaffold.dart';
import 'widgets/button.dart';
import 'widgets/dialog_list_tile.dart';
import 'widgets/number_list_tile.dart';

final _settings =
    BehaviorSubject<LineChartSettings>.seeded(const LineChartSettings());
final _style = BehaviorSubject<LineChartStyle>.seeded(const LineChartStyle());
final _data = BehaviorSubject<LineChartData>.seeded(LineChartData(
  gridType: LineChartGridType.undefined,
  data: {
    DateTime(2022, 7): -10000,
    DateTime(2022, 7, 02): -10000,
    DateTime(2022, 7, 03): -10000,
    DateTime(2022, 7, 04): -1185,
    DateTime(2022, 7, 05): -700,
    DateTime(2022, 7, 06): -700,
    DateTime(2022, 7, 07): -960.0,
    DateTime(2022, 7, 08): -1652.0,
    DateTime(2022, 7, 09): -2593.0,
    DateTime(2022, 7, 10): -690.0,
    DateTime(2022, 7, 11): -139.0,
    DateTime(2022, 7, 12): -55.0,
    DateTime(2022, 7, 13): 398.0,
    DateTime(2022, 7, 14): 742.0,
    DateTime(2022, 7, 15): 681.0,
    DateTime(2022, 7, 16): 711.0,
    DateTime(2022, 7, 17): 127.0,
    DateTime(2022, 7, 18): 110.0,
    DateTime(2022, 7, 19): 0,
    DateTime(2022, 7, 20): 100,
    DateTime(2022, 7, 21): 400,
    DateTime(2022, 7, 22): 1200,
    DateTime(2022, 7, 23): 2000,
    DateTime(2022, 7, 24): 1500,
    DateTime(2022, 7, 25): 4300,
    DateTime(2022, 7, 26): 10000,
    DateTime(2022, 7, 27): 5500,
    DateTime(2022, 7, 28): 1400,
    DateTime(2022, 7, 29): 0,
    DateTime(2022, 7, 30): -700,
    DateTime(2022, 7, 31): -950,
  },
));

class LineChartExample extends StatelessWidget {
  const LineChartExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SetupScaffold(
      body: _Chart(),
      setupChildren: [
        _GeneralDataSetupGroup(),
        SetupDivider(),
        _GridTypeSetupGroup(),
        SetupDivider(),
        _DataTypeSetupGroup(),
        SetupDivider(),
        _GeneralSettingsSetupGroup(),
        SetupDivider(),
        _AxisDivisionsEdgesSetupGroup(),
        SetupDivider(),
        _LimitLabelSnapPositionSetupGroup(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        return StreamBuilder<LineChartStyle>(
          stream: _style,
          initialData: _style.value,
          builder: (context, style) {
            return StreamBuilder<LineChartData>(
              stream: _data,
              initialData: _data.value,
              builder: (context, data) {
                return LineChart(
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
  const _GeneralDataSetupGroup({Key? key}) : super(key: key);

  Map<DateTime, double> getRandomizedData({required bool positive}) {
    final year = DateTime.now().year;
    final month = Random().nextInt(12) + 1;
    final days = Random().nextInt(20) + 8;
    final randomizedData = <DateTime, double>{};
    for (var i = 1, maxValue = 1000; i < days; i++) {
      final value = Random().nextInt(maxValue);
      maxValue += value;
      randomizedData[DateTime(year, month, i)] =
          positive ? value.toDouble() : 0 - value.toDouble();
    }

    return randomizedData;
  }

  Map<DateTime, double> getMixedRandomizedData() {
    final year = DateTime.now().year;
    final month = Random().nextInt(12) + 1;
    final days = Random().nextInt(5) * 4 + 8;
    final randomizedData = <DateTime, double>{};

    for (var i = 1, maxValue = 1000; i <= days / 4; i++) {
      final value = Random().nextInt(maxValue);
      maxValue += value;
      randomizedData[DateTime(year, month, i)] = -value.toDouble();
    }
    for (var i = 1, maxValue = 1000; i <= days / 4; i++) {
      final value = Random().nextInt(maxValue);
      maxValue -= value;
      randomizedData[DateTime(year, month, i + days ~/ 4)] = -value.toDouble();
    }
    for (var i = 1, maxValue = 1000; i <= days / 4; i++) {
      final value = Random().nextInt(maxValue);
      maxValue += value;
      randomizedData[DateTime(year, month, i + (days * 2) ~/ 4)] =
          value.toDouble();
    }
    for (var i = 1, maxValue = 1000; i <= days / 4; i++) {
      final value = Random().nextInt(maxValue);
      maxValue -= value;
      randomizedData[DateTime(year, month, i + (days * 3) ~/ 4)] =
          value.toDouble();
    }

    return randomizedData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartData>(
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
                }

                final doubleValue = double.tryParse(value!);
                _data.add(
                    data.requireData.copyWith(predefinedMaxValue: doubleValue));
              },
              title: const Text('predefinedMaxValue'),
            ),
            DialogListTile(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              value: data.requireData.limit?.toString(),
              onChanged: (value) {
                if (value == null) {
                  _data.add(data.requireData.copyWith(
                    allowNullLimit: true,
                    limit: null,
                  ));
                }

                final doubleValue = double.tryParse(value!);
                _data.add(data.requireData.copyWith(limit: doubleValue));
              },
              title: const Text('limit'),
            ),
            DialogListTile(
              value: data.requireData.limitText?.toString(),
              onChanged: (value) => _data.add(data.requireData.copyWith(
                allowNullLimitText: true,
                limitText: value,
              )),
              title: const Text('limitText'),
            ),
          ],
        );
      },
    );
  }
}

class _GridTypeSetupGroup extends StatelessWidget {
  const _GridTypeSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: 'Grid Type',
          children: [
            for (var i = 0; i < LineChartGridType.values.length; i++)
              RadioListTile<LineChartGridType>(
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: data.requireData.gridType,
                value: LineChartGridType.values[i],
                onChanged: (value) =>
                    _data.add(data.requireData.copyWith(gridType: value)),
                title: Text(LineChartGridType.values[i].name),
              ),
          ],
        );
      },
    );
  }
}

class _DataTypeSetupGroup extends StatelessWidget {
  const _DataTypeSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: 'Grid Type',
          children: [
            for (var i = 0; i < LineChartDataType.values.length; i++)
              RadioListTile<LineChartDataType>(
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: data.requireData.dataType,
                value: LineChartDataType.values[i],
                onChanged: (value) =>
                    _data.add(data.requireData.copyWith(dataType: value)),
                title: Text(LineChartDataType.values[i].name),
              ),
          ],
        );
      },
    );
  }
}

class _GeneralSettingsSetupGroup extends StatelessWidget {
  const _GeneralSettingsSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'General Settings',
          children: [
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.altitudeLine,
              onChanged: (value) =>
                  _settings.add(data.copyWith(altitudeLine: value == true)),
              title: const Text('altitudeLine'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.lineFilling,
              onChanged: (value) =>
                  _settings.add(data.copyWith(lineFilling: value == true)),
              title: const Text('lineFilling'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.lineShadow,
              onChanged: (value) =>
                  _settings.add(data.copyWith(lineShadow: value == true)),
              title: const Text('lineShadow'),
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
              value: data.showAxisXLabels,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisXLabels: value == true)),
              title: const Text('showAxisXLabels'),
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
              value: data.showAxisYLabels,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisYLabels: value == true)),
              title: const Text('showAxisYLabels'),
            ),
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
          ],
        );
      },
    );
  }
}

class _AxisDivisionsEdgesSetupGroup extends StatelessWidget {
  const _AxisDivisionsEdgesSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'Axis Division Edges',
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

class _LimitLabelSnapPositionSetupGroup extends StatelessWidget {
  const _LimitLabelSnapPositionSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'Limit Label Snap Position',
          children: [
            for (var i = 0; i < LimitLabelSnapPosition.values.length; i++)
              RadioListTile<LimitLabelSnapPosition>(
                controlAffinity: ListTileControlAffinity.trailing,
                groupValue: data.limitLabelSnapPosition,
                value: LimitLabelSnapPosition.values[i],
                onChanged: (value) =>
                    _settings.add(data.copyWith(limitLabelSnapPosition: value)),
                title: Text(LimitLabelSnapPosition.values[i].name),
              ),
          ],
        );
      },
    );
  }
}
