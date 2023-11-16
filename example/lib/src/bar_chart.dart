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

int _counter = 0;

final _settings =
    BehaviorSubject<BarChartSettings>.seeded(const BarChartSettings());
final _style = BehaviorSubject<BarChartStyle>.seeded(const BarChartStyle());
final _data = BehaviorSubject<BarChartData>.seeded(BarChartData(
  data: {
    DateTime(2013): [0, 0],
    DateTime(2014): [0, 20],
    DateTime(2015): [20, 0],
    DateTime(2016): [0, 0],
    DateTime(2017): [0, 0],
    DateTime(2018): [0, 200],
    DateTime(2019): [200, 0],
    DateTime(2020): [0, 0],
    DateTime(2021): [500, 500],
    DateTime(2022): [1234, 1000],
    DateTime(2023): [12345, 23456],
  },
));

class BarChartExample extends StatelessWidget {
  const BarChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupScaffold(
      body: _Chart(),
      setupChildren: [
        _GeneralDataSetupGroup(),
        SetupDivider(),
        _GeneralSettingsSetupGroup(),
        SetupDivider(),
        _IteractionTypeSetupGroup(),
        SetupDivider(),
        _BarAlignmentSetupGroup(),
        SetupDivider(),
        _BarFitSetupGroup(),
        SetupDivider(),
        _YAxisLayoutSetupGroup(),
        SetupDivider(),
        _AxisDivisionsEdgesSetupGroup(),
        SetupDivider(),
        _GridStyleSetupGroup(),
        SetupDivider(),
        _AxisStyleSetupGroup(),
        SetupDivider(),
        _BarStyleSetupGroup(),
        SetupDivider(),
        _BardBorderSetupGroup(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

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
  const _GeneralDataSetupGroup();

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
                const length = 10;
                final randomizedData = <DateTime, List<double>>{};
                for (var i = 0; i <= length; i++) {
                  final year = DateTime.now().year - length + i;
                  randomizedData[DateTime(year)] = [
                    Random().nextInt(50000).toDouble(),
                    Random().nextInt(50000).toDouble(),
                  ];
                }
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize Data'),
            ),
            Button(
              onPressed: () {
                final length = Random().nextInt(10);
                final yearBias = Random().nextInt(10);
                final randomizedData = <DateTime, List<double>>{};
                for (var i = 0; i <= length; i++) {
                  final year = DateTime.now().year - yearBias - length + i;
                  randomizedData[DateTime(year)] = [
                    Random().nextInt(50000).toDouble(),
                    Random().nextInt(50000).toDouble(),
                  ];
                }
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize Mixed Data'),
            ),
            Button(
              onPressed: () {
                final gridColor = Colors.white.withOpacity(0.1);
                final bar1Color = blend(
                  Colors.white,
                  Colors.blue,
                  intensityRed: 0.2,
                  intensityGreen: 0.2,
                  intensityBlue: 0.2,
                );
                final bar2Color = bar1Color.withOpacity(0.3);
                const selectedBar1Color = Colors.white;
                final selectedBar2Color = selectedBar1Color.withOpacity(0.8);
                final barWidth = _counter % 2 == 0
                    ? MediaQuery.of(context).size.width * 0.207
                    : 40.0;
                final alignment =
                    _counter % 2 == 0 ? BarAlignment.center : BarAlignment.end;

                const showAxisX = false;
                const yAxisDivisions = 3;
                const axisDivisionEdges = AxisDivisionEdges.vertical;
                const yAxisLayout = YAxisLayout.displace;
                const zeroBarTopRadius = 2.0;
                const barTopRadius = 6.0;
                const zeroBarHeight = 2.0;
                const gridStroke = 1.0;
                const barSpacing = -13.0;
                const borderStroke = 4.0;
                const border = BarBorder.bottom;
                const selectedShadowColor = Colors.black;
                const shadowElevation = 40.0;
                const fit = BarFit.contain;

                final data = BarChartData(
                  data: _counter % 2 == 0
                      ? {
                          DateTime(2000, 12): [1200, 800],
                        }
                      : {
                          DateTime(2020): [200, 100],
                          DateTime(2021): [50, 300],
                          DateTime(2022): [900, 900],
                          DateTime(2023): [1500, 300]
                        },
                  xAxisLabelBuilder: _counter % 2 == 0
                      ? (value, style) =>
                          TextSpan(text: 'Custom Label', style: style)
                      : BarChartData.defaultXAxisLabelBuilder,
                );
                final settings = BarChartSettings(
                  showAxisX: showAxisX,
                  yAxisDivisions: yAxisDivisions,
                  axisDivisionEdges: axisDivisionEdges,
                  barSpacing: barSpacing,
                  alignment: alignment,
                  fit: fit,
                  yAxisLayout: yAxisLayout,
                );
                final style = BarChartStyle(
                  gridStyle: BarChartGridStyle(
                    color: gridColor,
                    stroke: gridStroke,
                  ),
                  barStyle: BarChartBarStyle(
                    width: barWidth,
                    colors: [bar1Color, bar2Color],
                    selectedColors: [selectedBar1Color, selectedBar2Color],
                    selectedBorderColors: [Colors.green, Colors.red],
                    borderStroke: borderStroke,
                    border: border,
                    selectedShadowColor: selectedShadowColor,
                    shadowElevation: shadowElevation,
                    zeroBarHeight: zeroBarHeight,
                    topRadius: barTopRadius,
                    zeroBarTopRadius: zeroBarTopRadius,
                  ),
                );

                _data.add(data);
                _style.add(style);
                _settings.add(settings);

                _counter++;
              },
              title: const Text('Randomize Test Data'),
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
            IntListTile(
              value: data.yAxisLabelSpacing.toInt(),
              onChanged: (value) {
                final doubleValue = value.toDouble();
                _settings.add(data.copyWith(yAxisLabelSpacing: doubleValue));
              },
              title: const Text('yAxisLabelSpacing'),
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

class _IteractionTypeSetupGroup extends StatelessWidget {
  const _IteractionTypeSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Interaction Type',
          children: [
            for (var i = 0; i < InteractionType.values.length; i++)
              RadioListTile<InteractionType>(
                controlAffinity: ListTileControlAffinity.leading,
                groupValue: data.interaction,
                value: InteractionType.values[i],
                onChanged: (value) =>
                    _settings.add(data.copyWith(interaction: value)),
                title: Text(InteractionType.values[i].name),
              ),
          ],
        );
      },
    );
  }
}

class _BarAlignmentSetupGroup extends StatelessWidget {
  const _BarAlignmentSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Bar Alignment',
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

class _BarFitSetupGroup extends StatelessWidget {
  const _BarFitSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Bar Fit',
          children: [
            for (var i = 0; i < BarFit.values.length; i++)
              RadioListTile<BarFit>(
                controlAffinity: ListTileControlAffinity.leading,
                groupValue: data.fit,
                value: BarFit.values[i],
                onChanged: (value) => _settings.add(data.copyWith(fit: value)),
                title: Text(BarFit.values[i].name),
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
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Y Axis Layout',
          children: [
            for (var i = 0; i < YAxisLayout.values.length; i++)
              RadioListTile<YAxisLayout>(
                controlAffinity: ListTileControlAffinity.leading,
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
    return StreamBuilder<BarChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: '└─ Axis Division Edges',
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
  const _GridStyleSetupGroup();

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
  const _AxisStyleSetupGroup();

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
  const _BarStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;
        final colorLength = _data.value.data.values.first.length;

        return SetupGroup(
          title: 'Bar Style',
          children: [
            for (var i = 0; i < colorLength; i++)
              ColorListTile(
                value: data.barStyle.colors.length == 1
                    ? data.barStyle.colors.first
                    : data.barStyle.colors[i],
                onChanged: (value) {
                  final colors = Map.of(data.barStyle.colors.asMap());
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
            for (var i = 0; i < colorLength; i++)
              ColorListTile(
                value: data.barStyle.selectedColors == null
                    ? Colors.transparent
                    : i < data.barStyle.selectedColors!.length
                        ? data.barStyle.selectedColors![i]
                        : Colors.transparent,
                onChanged: (value) {
                  final colors = Map.of(
                      data.barStyle.selectedColors?.asMap() ?? <int, Color>{});
                  colors[i] = value;

                  _style.add(
                    data.copyWith(
                      barStyle: data.barStyle.copyWith(
                        allowNullSelectedColors: true,
                        selectedColors: colors.values.toList(),
                      ),
                    ),
                  );
                },
                title: Text('selectedColor ${i + 1}'),
              ),
            for (var i = 0; i < colorLength; i++)
              ColorListTile(
                value: data.barStyle.borderColors == null
                    ? Colors.transparent
                    : i < data.barStyle.borderColors!.length
                        ? data.barStyle.borderColors![i]
                        : Colors.transparent,
                onChanged: (value) {
                  final colors = Map.of(
                      data.barStyle.borderColors?.asMap() ?? <int, Color>{});
                  colors[i] = value;

                  _style.add(
                    data.copyWith(
                      barStyle: data.barStyle.copyWith(
                        allowNullBorderColors: true,
                        borderColors: colors.values.toList(),
                      ),
                    ),
                  );
                },
                title: Text('borderColors ${i + 1}'),
              ),
            for (var i = 0; i < colorLength; i++)
              ColorListTile(
                value: data.barStyle.selectedBorderColors == null
                    ? Colors.transparent
                    : i < data.barStyle.selectedBorderColors!.length
                        ? data.barStyle.selectedBorderColors![i]
                        : Colors.transparent,
                onChanged: (value) {
                  final colors = Map.of(
                      data.barStyle.selectedBorderColors?.asMap() ??
                          <int, Color>{});
                  colors[i] = value;

                  _style.add(
                    data.copyWith(
                      barStyle: data.barStyle.copyWith(
                        allowNullSelectedBorderColors: true,
                        selectedBorderColors: colors.values.toList(),
                      ),
                    ),
                  );
                },
                title: Text('selectedBorderColors ${i + 1}'),
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
              value: data.barStyle.borderStroke.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      borderStroke: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('borderStroke'),
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
            ColorListTile(
              value: data.barStyle.shadowColor ?? Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      shadowColor: value,
                    ),
                  ),
                );
              },
              title: const Text('shadowColor'),
            ),
            ColorListTile(
              value: data.barStyle.selectedShadowColor ?? Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      selectedShadowColor: value,
                    ),
                  ),
                );
              },
              title: const Text('selectedShadowColor'),
            ),
            IntListTile(
              value: data.barStyle.shadowElevation.toInt(),
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    barStyle: data.barStyle.copyWith(
                      shadowElevation: value.toDouble(),
                    ),
                  ),
                );
              },
              title: const Text('shadowElevation'),
            ),
          ],
        );
      },
    );
  }
}

class _BardBorderSetupGroup extends StatelessWidget {
  const _BardBorderSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BarChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: '└─ Bar Borders',
          children: [
            for (var i = 0; i < BarBorder.values.length; i++)
              RadioListTile<BarBorder>(
                controlAffinity: ListTileControlAffinity.leading,
                groupValue: data.barStyle.border,
                value: BarBorder.values[i],
                onChanged: (value) {
                  _style.add(
                    data.copyWith(
                      barStyle: data.barStyle.copyWith(
                        border: value,
                      ),
                    ),
                  );
                },
                title: Text(AxisDivisionEdges.values[i].name),
              ),
          ],
        );
      },
    );
  }
}

Color blend(
  Color input1,
  Color input2, {
  double intensityAlpha = 1,
  double intensityRed = 1,
  double intensityGreen = 1,
  double intensityBlue = 1,
}) {
  final color = Color.fromARGB(
    (input2.alpha + input2.alpha) ~/ 2,
    (input2.red + input2.red) ~/ 2,
    (input2.green + input2.green) ~/ 2,
    (input2.blue + input2.blue) ~/ 2,
  );
  return color;
}
