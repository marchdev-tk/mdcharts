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
    DateTime(2022, 7, 07): -960,
    DateTime(2022, 7, 08): -1652,
    DateTime(2022, 7, 09): -2593,
    DateTime(2022, 7, 10): -690,
    DateTime(2022, 7, 11): -139,
    DateTime(2022, 7, 12): -55,
    DateTime(2022, 7, 13): 398,
    DateTime(2022, 7, 14): 742,
    DateTime(2022, 7, 15): 681,
    DateTime(2022, 7, 16): 711,
    DateTime(2022, 7, 17): 127,
    DateTime(2022, 7, 18): 110,
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
  const LineChartExample({super.key});

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
        _YAxisLayoutSetupGroup(),
        SetupDivider(),
        _AxisDivisionsEdgesSetupGroup(),
        SetupDivider(),
        _LimitLabelSnapPositionSetupGroup(),
        SetupDivider(),
        _GridStyleSetupGroup(),
        SetupDivider(),
        _AxisStyleSetupGroup(),
        // SetupDivider(),
        // lineStyle
        // SetupDivider(),
        // limitStyle
        SetupDivider(),
        _DropLineStyleSetupGroup(),
        // SetupDivider(),
        // pointStyle
        SetupDivider(),
        _TooltipStyleSetupGroup(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

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
  const _GeneralDataSetupGroup();

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

  Map<DateTime, double> getTestData() {
    return {
      DateTime(2023): Random().nextInt(6700).toDouble(),
      DateTime(2023, 1, 2): Random().nextInt(12310).toDouble(),
      DateTime(2023, 3, 3): Random().nextInt(12310).toDouble(),
      DateTime(2023, 1, 4): Random().nextInt(12310).toDouble(),
      DateTime(2023, 5, 5): Random().nextInt(12310).toDouble(),
      DateTime(2023, 1, 6): Random().nextInt(12310).toDouble(),
      DateTime(2023, 6, 7): Random().nextInt(12310).toDouble(),
      DateTime(2023, 1, 8): Random().nextInt(12310).toDouble(),
      DateTime(2023, 8, 9): Random().nextInt(12310).toDouble(),
      DateTime(2023, 1, 10): Random().nextInt(12310).toDouble(),
      DateTime(2023, 11, 11): Random().nextInt(12310).toDouble(),
      DateTime(2023, 1, 12): Random().nextInt(12310).toDouble(),
    };
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
            Button(
              onPressed: () {
                final randomizedData = getTestData();

                const materialColor = Colors.white;
                final chartColor =
                    randomizedData.values.first < randomizedData.values.last
                        ? Colors.green
                        : Colors.red;

                const settings = LineChartSettings(
                  xAxisDivisions: 0,
                  yAxisDivisions: 3,
                  xAxisLabelQuantity: 5,
                  axisDivisionEdges: AxisDivisionEdges.vertical,
                  showAxisY: false,
                );
                final style = LineChartStyle(
                  gridStyle: GridStyle.same(
                    color: materialColor.withOpacity(0.1),
                    stroke: 0.5,
                  ),
                  axisStyle: AxisStyle(
                    color: materialColor.withOpacity(0.1),
                    stroke: 0.5,
                    xAxisLabelTopMargin: 6,
                    xAxisLabelStyle: const TextStyle(
                      height: 16 / 11,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: materialColor,
                    ),
                    yAxisLabelStyle: TextStyle(
                      height: 16 / 11,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: materialColor.withOpacity(0.2),
                    ),
                  ),
                  lineStyle: LineChartLineStyle(
                    color: chartColor,
                    colorInactive: chartColor.withOpacity(0.2),
                    altitudeLineColor: materialColor.withOpacity(0.1),
                    fillGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        chartColor.withOpacity(0.5),
                        chartColor.withOpacity(0.12),
                        chartColor.withOpacity(0.08),
                        chartColor.withOpacity(0.01),
                      ],
                      stops: const [0.0604, 0.3353, 0.6102, 1],
                    ),
                  ),
                  dropLineStyle: DropLineStyle(
                    color: materialColor.withOpacity(0.5),
                  ),
                  pointStyle: LineChartPointStyle(
                    innerColor: materialColor,
                    outerColor: chartColor,
                  ),
                  tooltipStyle: const TooltipStyle(
                    color: materialColor,
                  ),
                );

                _data.add(_data.value.copyWith(
                  data: randomizedData,
                  gridType: LineChartGridType.undefined,
                ));
                _settings.add(settings);
                _style.add(style);
              },
              title: const Text('Randomize with Test Data'),
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
                  return;
                }

                final doubleValue = double.tryParse(value);
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
  const _GridTypeSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: '└─ Grid Type',
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
  const _DataTypeSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: '└─ Data Type',
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
  const _GeneralSettingsSetupGroup();

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
              value: data.showDropLine,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showDropLine: value == true)),
              title: const Text('showDropLine'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showTooltip,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showTooltip: value == true)),
              title: const Text('showTooltip'),
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
              value: data.altitudeLine,
              onChanged: (value) =>
                  _settings.add(data.copyWith(altitudeLine: value == true)),
              title: const Text('altitudeLine'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showPoint,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showPoint: value == true)),
              title: const Text('showPoint'),
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
    return StreamBuilder<LineChartSettings>(
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
    return StreamBuilder<LineChartSettings>(
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

class _LimitLabelSnapPositionSetupGroup extends StatelessWidget {
  const _LimitLabelSnapPositionSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Limit Label Snap Position',
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

class _GridStyleSetupGroup extends StatelessWidget {
  const _GridStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartStyle>(
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
    return StreamBuilder<LineChartStyle>(
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

class _DropLineStyleSetupGroup extends StatelessWidget {
  const _DropLineStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Drop Line Style',
          children: [
            ColorListTile(
              value: data.dropLineStyle.color,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      color: value,
                    ),
                  ),
                );
              },
              title: const Text('color'),
            ),
            IntListTile(
              value: data.dropLineStyle.stroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      stroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('stroke'),
            ),
            IntListTile(
              value: data.dropLineStyle.dashSize.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      dashSize: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('dashSize'),
            ),
            IntListTile(
              value: data.dropLineStyle.gapSize.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      gapSize: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('gapSize'),
            ),
          ],
        );
      },
    );
  }
}

class _TooltipStyleSetupGroup extends StatelessWidget {
  const _TooltipStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LineChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Tooltip Style',
          children: [
            ColorListTile(
              value: data.tooltipStyle.color,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      color: value,
                    ),
                  ),
                );
              },
              title: const Text('color'),
            ),
            IntListTile(
              value: data.tooltipStyle.spacing.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      spacing: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('spacing'),
            ),
            IntListTile(
              value: data.tooltipStyle.radius.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      radius: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('radius'),
            ),
            IntListTile(
              value: data.tooltipStyle.triangleWidth.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      triangleWidth: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('triangleWidth'),
            ),
            IntListTile(
              value: data.tooltipStyle.triangleHeight.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      triangleHeight: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('triangleHeight'),
            ),
            ColorListTile(
              value: data.tooltipStyle.shadowColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      shadowColor: value,
                    ),
                  ),
                );
              },
              title: const Text('shadowColor'),
            ),
            IntListTile(
              value: data.tooltipStyle.shadowElevation.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      shadowElevation: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('shadowElevation'),
            ),
            IntListTile(
              value: data.tooltipStyle.bottomMargin.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    tooltipStyle: data.tooltipStyle.copyWith(
                      bottomMargin: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('bottomMargin'),
            ),
          ],
        );
      },
    );
  }
}
