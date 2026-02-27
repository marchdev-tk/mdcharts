// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
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
    const CandlestickChartSettings(
        axisDivisionEdges: AxisDivisionEdges.vertical));
final _style = BehaviorSubject<CandlestickChartStyle>.seeded(
    const CandlestickChartStyle());
final _data = BehaviorSubject<CandlestickChartData>.seeded(CandlestickChartData(
  data: {
    DateTime(2022, 7):
        const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
    DateTime(2022, 7, 02):
        const CandlestickData(low: 0, high: 50, bid: 50, ask: 20),
    DateTime(2022, 7, 03):
        const CandlestickData(low: 300, high: 450, bid: 350, ask: 320),
    DateTime(2022, 7, 04):
        const CandlestickData(low: 200, high: 250, bid: 200, ask: 250),
    DateTime(2022, 7, 05):
        const CandlestickData(low: 220, high: 250, bid: 230, ask: 230),
    DateTime(2022, 7, 06):
        const CandlestickData(low: 250, high: 350, bid: 250, ask: 250),
    DateTime(2022, 7, 07):
        const CandlestickData(low: 330, high: 450, bid: 350, ask: 400),
    DateTime(2022, 7, 08):
        const CandlestickData(low: 400, high: 650, bid: 550, ask: 500),
    DateTime(2022, 7, 09):
        const CandlestickData(low: 500, high: 750, bid: 520, ask: 700),
    DateTime(2022, 7, 10):
        const CandlestickData(low: 700, high: 950, bid: 850, ask: 800),
    DateTime(2022, 7, 11):
        const CandlestickData(low: 600, high: 750, bid: 630, ask: 700),
    DateTime(2022, 7, 12):
        const CandlestickData(low: 550, high: 900, bid: 650, ask: 800),
    DateTime(2022, 7, 13):
        const CandlestickData(low: 430, high: 650, bid: 450, ask: 430),
    DateTime(2022, 7, 14):
        const CandlestickData(low: 370, high: 400, bid: 400, ask: 380),
    DateTime(2022, 7, 15):
        const CandlestickData(low: 310, high: 750, bid: 710, ask: 500),
    DateTime(2022, 7, 16):
        const CandlestickData(low: 250, high: 600, bid: 450, ask: 460),
    DateTime(2022, 7, 17):
        const CandlestickData(low: 200, high: 500, bid: 400, ask: 200),
    DateTime(2022, 7, 18):
        const CandlestickData(low: 500, high: 850, bid: 500, ask: 850),
    DateTime(2022, 7, 19):
        const CandlestickData(low: 800, high: 1250, bid: 1250, ask: 800),
    DateTime(2022, 7, 20):
        const CandlestickData(low: 900, high: 1250, bid: 1050, ask: 1200),
    DateTime(2022, 7, 21):
        const CandlestickData(low: 1000, high: 1650, bid: 1550, ask: 1200),
    DateTime(2022, 7, 22):
        const CandlestickData(low: 1300, high: 1950, bid: 1800, ask: 1400),
    DateTime(2022, 7, 23):
        const CandlestickData(low: 1700, high: 2200, bid: 2050, ask: 1800),
    DateTime(2022, 7, 24):
        const CandlestickData(low: 1900, high: 3020, bid: 2850, ask: 2000),
    DateTime(2022, 7, 25):
        const CandlestickData(low: 2300, high: 4050, bid: 3800, ask: 2500),
    DateTime(2022, 7, 26):
        const CandlestickData(low: 2700, high: 3500, bid: 3400, ask: 3000),
    DateTime(2022, 7, 27):
        const CandlestickData(low: 3100, high: 4100, bid: 4100, ask: 3200),
    DateTime(2022, 7, 28):
        const CandlestickData(low: 3800, high: 6050, bid: 5800, ask: 4000),
    DateTime(2022, 7, 29):
        const CandlestickData(low: 4500, high: 8000, bid: 7500, ask: 5200),
    DateTime(2022, 7, 30):
        const CandlestickData(low: 3000, high: 7000, bid: 4000, ask: 6200),
    DateTime(2022, 7, 31):
        const CandlestickData(low: 1500, high: 2250, bid: 1700, ask: 2000),
  },
  subtitleBuilder: (key, value) {
    final doubleValue = CandlestickChartData.getSelectedValueFromData(value);
    return doubleValue.toString();
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
        _YAxisBasisSetupGroup(),
        SetupDivider(),
        _AxisDivisionsEdgesSetupGroup(),
        SetupDivider(),
        _GridStyleSetupGroup(),
        SetupDivider(),
        _AxisStyleSetupGroup(),
        SetupDivider(),
        _ZeroLineStyleSetupGroup(),
        SetupDivider(),
        _DropLineStyleSetupGroup(),
        SetupDivider(),
        _CandleStickStyleSetupGroup(),
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
    final bidBias =
        maxBidAskBias == 0 ? 0 : Random().nextInt(maxBidAskBias).toDouble();
    final askBias =
        maxBidAskBias == 0 ? 0 : Random().nextInt(maxBidAskBias).toDouble();

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

    for (var i = 1; i <= days; i++) {
      randomizedData[DateTime(year, month, i)] =
          _generateData(positive: Random().nextBool());
    }

    return randomizedData;
  }

  Map<DateTime, CandlestickData> getIotaData() {
    final year = DateTime.now().year;
    final month = Random().nextInt(12) + 1;
    final randomizedData = <DateTime, CandlestickData>{};

    for (var i = 1; i <= 5; i++) {
      final low = Random().nextDouble() / 100;
      final high = (low + Random().nextDouble() / 100);
      final bid = (high * Random().nextDouble()).clamp(low, high);
      final ask = (high * Random().nextDouble()).clamp(low, high);

      randomizedData[DateTime(year, month, i)] = CandlestickData(
        low: low,
        high: high,
        bid: bid,
        ask: ask,
      );
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
            Button(
              onPressed: () {
                final randomizedData = getIotaData();
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize with Iota Data'),
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
              value: data.defaultDivisionInterval.toInt(),
              onChanged: (value) => _settings.add(
                  data.copyWith(defaultDivisionInterval: value.toDouble())),
              title: const Text('defaultDivisionInterval'),
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
              value: data.showAxisXLabelSelection,
              onChanged: (value) => _settings
                  .add(data.copyWith(showAxisXLabelSelection: value == true)),
              title: const Text('showAxisXLabelSelection'),
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
              value: data.showZeroLine,
              onChanged: (value) =>
                  _settings.add(data.copyWith(showZeroLine: value == true)),
              title: const Text('showZeroLine'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisXDropLine,
              onChanged: (value) => _settings
                  .add(data.copyWith(showAxisXDropLine: value == true)),
              title: const Text('showAxisXDropLine'),
            ),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.trailing,
              value: data.showAxisYDropLine,
              onChanged: (value) => _settings
                  .add(data.copyWith(showAxisYDropLine: value == true)),
              title: const Text('showAxisYDropLine'),
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

        return RadioGroup(
          onChanged: (value) =>
              _settings.add(data.copyWith(yAxisLayout: value)),
          groupValue: data.yAxisLayout,
          child: SetupGroup(
            title: '└─ Y Axis Layout',
            children: [
              for (var i = 0; i < YAxisLayout.values.length; i++)
                RadioListTile<YAxisLayout>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: YAxisLayout.values[i],
                  title: Text(YAxisLayout.values[i].name),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _YAxisBasisSetupGroup extends StatelessWidget {
  const _YAxisBasisSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return RadioGroup(
          onChanged: (value) =>
              _settings.add(data.copyWith(yAxisBaseline: value)),
          groupValue: data.yAxisBaseline,
          child: SetupGroup(
            title: '└─ Y Axis Baseline',
            children: [
              for (var i = 0; i < YAxisBaseline.values.length; i++)
                RadioListTile<YAxisBaseline>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: YAxisBaseline.values[i],
                  title: Text(YAxisBaseline.values[i].name),
                ),
            ],
          ),
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

        return RadioGroup(
          onChanged: (value) =>
              _settings.add(data.copyWith(axisDivisionEdges: value)),
          groupValue: data.axisDivisionEdges,
          child: SetupGroup(
            title: '└─ Axis Division Edges',
            children: [
              for (var i = 0; i < AxisDivisionEdges.values.length; i++)
                RadioListTile<AxisDivisionEdges>(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: AxisDivisionEdges.values[i],
                  title: Text(AxisDivisionEdges.values[i].name),
                ),
            ],
          ),
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

class _ZeroLineStyleSetupGroup extends StatelessWidget {
  const _ZeroLineStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Zero Line Style',
          children: [
            IntListTile(
              value: data.zeroLineStyle.stroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    zeroLineStyle: data.zeroLineStyle.copyWith(
                      stroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('stroke'),
            ),
            ColorListTile(
              value: data.zeroLineStyle.color,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    zeroLineStyle: data.zeroLineStyle.copyWith(
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

class _DropLineStyleSetupGroup extends StatelessWidget {
  const _DropLineStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CandlestickChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Drop Line Style',
          children: [
            ColorListTile(
              value: data.dropLineStyle.color ?? Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullXAxisGradient: true,
                      allowNullYAxisGradient: true,
                      color: value,
                      xAxisGradient: null,
                      yAxisGradient: null,
                    ),
                  ),
                );
              },
              title: const Text('color'),
            ),
            Button(
              onPressed: () {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullColor: true,
                      color: null,
                    ),
                  ),
                );
              },
              title: const Text('Clear color'),
            ),
            ColorListTile(
              value: data.dropLineStyle.xAxisGradient?.colors.first ??
                  Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullColor: true,
                      color: null,
                      xAxisGradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          value,
                          data.dropLineStyle.xAxisGradient?.colors.last ??
                              Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
              title: const Text('xAxisGradient first color'),
            ),
            ColorListTile(
              value: data.dropLineStyle.xAxisGradient?.colors.last ??
                  Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullColor: true,
                      color: null,
                      xAxisGradient: LinearGradient(
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                        colors: [
                          data.dropLineStyle.xAxisGradient?.colors.first ??
                              Colors.transparent,
                          value,
                        ],
                      ),
                    ),
                  ),
                );
              },
              title: const Text('xAxisGradient last color'),
            ),
            Button(
              onPressed: () {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullXAxisGradient: true,
                      xAxisGradient: null,
                    ),
                  ),
                );
              },
              title: const Text('Clear xAxisGradient'),
            ),
            ColorListTile(
              value: data.dropLineStyle.yAxisGradient?.colors.first ??
                  Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullColor: true,
                      color: null,
                      yAxisGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          value,
                          data.dropLineStyle.yAxisGradient?.colors.last ??
                              Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
              title: const Text('yAxisGradient first color'),
            ),
            ColorListTile(
              value: data.dropLineStyle.yAxisGradient?.colors.last ??
                  Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullColor: true,
                      color: null,
                      yAxisGradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          data.dropLineStyle.yAxisGradient?.colors.first ??
                              Colors.transparent,
                          value,
                        ],
                      ),
                    ),
                  ),
                );
              },
              title: const Text('yAxisGradient last color'),
            ),
            Button(
              onPressed: () {
                _style.add(
                  data.copyWith(
                    dropLineStyle: data.dropLineStyle.copyWith(
                      allowNullYAxisGradient: true,
                      yAxisGradient: null,
                    ),
                  ),
                );
              },
              title: const Text('Clear yAxisGradient'),
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
    return StreamBuilder<CandlestickChartStyle>(
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
