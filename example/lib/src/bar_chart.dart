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

final _settings =
    BehaviorSubject<BarChartSettings>.seeded(const BarChartSettings());
final _style = BehaviorSubject<BarChartStyle>.seeded(const BarChartStyle());
final _data = BehaviorSubject<BarChartData>.seeded(BarChartData(
  data: {
    DateTime(2012): [0, 0],
    DateTime(2013): [0, 20],
    DateTime(2014): [20, 0],
    DateTime(2015): [0, 0],
    DateTime(2016): [0, 0],
    DateTime(2017): [0, 200],
    DateTime(2018): [200, 0],
    DateTime(2019): [0, 0],
    DateTime(2020): [500, 500],
    DateTime(2021): [1234, 1000],
    DateTime(2022): [12345, 23456],
  },
));

class BarChartExample extends StatelessWidget {
  const BarChartExample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SetupScaffold(
      body: _Chart(),
      setupChildren: [
        _GeneralDataSetupGroup(),
        SetupDivider(),
        _GeneralSettingsSetupGroup(),
        SetupDivider(),
        _BarAlignmentSetupGroup(),
        SetupDivider(),
        _AxisDivisionsEdgesSetupGroup(),
        SetupDivider(),
        _GridStyleSetupGroup(),
        SetupDivider(),
        _AxisStyleSetupGroup(),
        SetupDivider(),
        _BarStyleSetupGroup(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        return StreamBuilder<BarChartStyle>(
          stream: _style,
          initialData: _style.value,
          builder: (context, style) {
            return StreamBuilder<BarChartData>(
              stream: _data,
              initialData: _data.value,
              builder: (context, data) {
                return BarChart(
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: 'General Data',
          children: [
            Button(
              onPressed: () {
                final randomizedData = <DateTime, List<double>>{};
                for (var i = 0; i < 11; i++) {
                  randomizedData[DateTime(DateTime.now().year - i)] = [
                    Random().nextInt(50000).toDouble(),
                    Random().nextInt(50000).toDouble(),
                  ];
                }
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize Data'),
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
  const _GeneralSettingsSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'General Settings',
          children: [
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: data.showAxisX,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisX: value == true)),
              title: const Text('showAxisX'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: data.showAxisXLabels,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisXLabels: value == true)),
              title: const Text('showAxisXLabels'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: data.showAxisYLabels,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showAxisYLabels: value == true)),
              title: const Text('showAxisYLabels'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: data.showSelection,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showSelection: value == true)),
              title: const Text('showSelection'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              value: data.reverse,
              onChanged: (value) =>
                  _settings.add(data.copyWith(reverse: value == true)),
              title: const Text('reverse'),
            ),
            IntListTile(
              value: data.yAxisDivisions,
              onChanged: (value) =>
                  _settings.add(data.copyWith(yAxisDivisions: value)),
              title: const Text('yAxisDivisions'),
            ),
            IntListTile(
              value: data.barSpacing.toInt(),
              onChanged: (value) {
                final doubleValue = value.toDouble();
                _settings.add(data.copyWith(barSpacing: doubleValue));
              },
              title: const Text('barSpacing'),
            ),
            IntListTile(
              value: data.itemSpacing.toInt(),
              onChanged: (value) {
                final doubleValue = value.toDouble();
                _settings.add(data.copyWith(itemSpacing: doubleValue));
              },
              title: const Text('itemSpacing'),
            ),
          ],
        );
      },
    );
  }
}

class _BarAlignmentSetupGroup extends StatelessWidget {
  const _BarAlignmentSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'Bar Alignment',
          children: [
            for (var i = 0; i < BarAlignment.values.length; i++)
              RadioListTile<BarAlignment>(
                controlAffinity: ListTileControlAffinity.leading,
                groupValue: data.alignment,
                value: BarAlignment.values[i],
                onChanged: (value) =>
                    _settings.add(data.copyWith(alignment: value)),
                title: Text(BarAlignment.values[i].name),
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
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'Axis Division Edges',
          children: [
            for (var i = 0; i < AxisDivisionEdges.values.length; i++)
              RadioListTile<AxisDivisionEdges>(
                controlAffinity: ListTileControlAffinity.leading,
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
  const _GridStyleSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Grid Style',
          children: [
            IntListTile(
              value: data.gridStyle.stroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    gridStyle: data.gridStyle.copyWith(
                      stroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('stroke'),
            ),
            ColorListTile(
              value: data.gridStyle.color,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    gridStyle: data.gridStyle.copyWith(
                      color: value,
                    ),
                  ),
                );
              },
              title: const Text('color'),
            ),
          ],
        );
      },
    );
  }
}

class _AxisStyleSetupGroup extends StatelessWidget {
  const _AxisStyleSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartStyle>(
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

class _BarStyleSetupGroup extends StatelessWidget {
  const _BarStyleSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;
        final colorLength = _data.value.data.values.first.length;
        final singleColor = data.barStyle.colors.length == 1;

        return SetupGroup(
          title: 'Bar Style',
          children: [
            for (var i = 0; i < colorLength; i++)
              ColorListTile(
                value: singleColor
                    ? data.barStyle.colors.first
                    : data.barStyle.colors[i],
                onChanged: (value) {
                  final colors = data.barStyle.colors.asMap();
                  colors[i] = value;

                  _style.add(
                    data.copyWith(
                      barStyle: data.barStyle.copyWith(
                        colors: colors.values.toList(),
                      ),
                    ),
                  );
                },
                title: Text('color ${i + 1}'),
              ),
            IntListTile(
              value: data.barStyle.width.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      width: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('width'),
            ),
            IntListTile(
              value: data.barStyle.zeroBarHeight.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      zeroBarHeight: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('zeroBarHeight'),
            ),
            IntListTile(
              value: data.barStyle.topRadius.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      topRadius: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('topRadius'),
            ),
            IntListTile(
              value: data.barStyle.zeroBarTopRadius.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      zeroBarTopRadius: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('zeroBarTopRadius'),
            ),
          ],
        );
      },
    );
  }
}
