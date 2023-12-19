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

final _settings = BehaviorSubject<DonutChartSettings>.seeded(
  const DonutChartSettings(colorPattern: [0, 1]),
);
final _style = BehaviorSubject<DonutChartStyle>.seeded(
  const DonutChartStyle(
    sectionStyle: DonutChartSectionStyle(
      colors: [Colors.blue, Colors.yellow],
    ),
  ),
);
final _data = BehaviorSubject<DonutChartData>.seeded(
  const DonutChartData(data: [524, 306], initialSelectedIndex: 0),
);

class DonutChartExample extends StatelessWidget {
  const DonutChartExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const SetupScaffold(
      body: _Chart(),
      setupChildren: [
        _GeneralDataSetupGroup(),
        SetupDivider(),
        _GeneralSettingsSetupGroup(),
        SetupDivider(),
        _BackgroundStyleSetupGroup(),
        SetupDivider(),
        _SectionStyleSetupGroup(),
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DonutChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        return StreamBuilder<DonutChartStyle>(
          stream: _style,
          initialData: _style.value,
          builder: (context, style) {
            return StreamBuilder<DonutChartData>(
              stream: _data,
              initialData: _data.value,
              builder: (context, data) {
                return DonutChart(
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

  List<double> getRandomizedData({required bool fixedQty}) {
    if (fixedQty) {
      return [
        Random().nextInt(100000) / 100,
        Random().nextInt(100000) / 100,
      ];
    }

    final randomizedData = <double>[];
    final count = Random().nextInt(4) + 1;

    for (var i = 0; i < count; i++) {
      randomizedData.add(Random().nextInt(100000) / 100);
    }

    return randomizedData;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DonutChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return SetupGroup(
          title: 'General Data',
          children: [
            Button(
              onPressed: () {
                final randomizedData = getRandomizedData(fixedQty: true);
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize with Fixed Qty'),
            ),
            Button(
              onPressed: () {
                final randomizedData = getRandomizedData(fixedQty: false);
                _data.add(_data.value.copyWith(data: randomizedData));
              },
              title: const Text('Randomize with Random Qty'),
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
    return StreamBuilder<DonutChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        final data = settings.requireData;

        return SetupGroup(
          title: 'General Settings',
          children: [
            DialogListTile(
              value: data.colorPattern
                  ?.toString()
                  .replaceAll(' ', '')
                  .replaceAll('[', '')
                  .replaceAll(']', ''),
              onChanged: (value) {
                if (value == null) {
                  _settings.add(data.copyWith(
                    allowNullColorPattern: true,
                    colorPattern: null,
                  ));
                  return;
                }

                final list =
                    value.split(',').map((e) => int.parse(e.trim())).toList();
                _settings.add(data.copyWith(colorPattern: list));
              },
              title: const Text('colorPattern (comma separated values)'),
            ),
            IntListTile(
              value: data.sectionStroke.toInt(),
              onChanged: (value) =>
                  _settings.add(data.copyWith(sectionStroke: value.toDouble())),
              title: const Text('sectionStroke'),
            ),
            IntListTile(
              value: data.selectedSectionStroke.toInt(),
              onChanged: (value) => _settings
                  .add(data.copyWith(selectedSectionStroke: value.toDouble())),
              title: const Text('selectedSectionStroke'),
            ),
            CheckboxListTile(
              value: data.debugMode,
              onChanged: (value) =>
                  _settings.add(data.copyWith(debugMode: value)),
              title: const Text('debugMode'),
            ),
            CheckboxListTile(
              value: data.selectionEnabled,
              onChanged: (value) =>
                  _settings.add(data.copyWith(selectionEnabled: value)),
              title: const Text('selectionEnabled'),
            ),
          ],
        );
      },
    );
  }
}

class _BackgroundStyleSetupGroup extends StatelessWidget {
  const _BackgroundStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DonutChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Background Style',
          children: [
            ColorListTile(
              value: data.backgroundStyle.color,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    backgroundStyle: data.backgroundStyle.copyWith(
                      color: value,
                    ),
                  ),
                );
              },
              title: const Text('color'),
            ),
            ColorListTile(
              value: data.backgroundStyle.shadowColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    backgroundStyle: data.backgroundStyle.copyWith(
                      shadowColor: value,
                    ),
                  ),
                );
              },
              title: const Text('shadowColor'),
            ),
            IntListTile(
              value: data.backgroundStyle.shadowElevation.toInt(),
              onChanged: (value) => _style.add(
                data.copyWith(
                  backgroundStyle: data.backgroundStyle.copyWith(
                    shadowElevation: value.toDouble(),
                  ),
                ),
              ),
              title: const Text('shadowElevation'),
            ),
          ],
        );
      },
    );
  }
}

class _SectionStyleSetupGroup extends StatelessWidget {
  const _SectionStyleSetupGroup();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DonutChartStyle>(
      stream: _style,
      initialData: _style.value,
      builder: (context, style) {
        final data = style.requireData;

        return SetupGroup(
          title: 'Section Style',
          children: [
            ColorListTile(
              value: data.sectionStyle.selectedColor,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    sectionStyle: data.sectionStyle.copyWith(
                      selectedColor: value,
                    ),
                  ),
                );
              },
              title: const Text('selectedColor'),
            ),
            for (var i = 0; i < data.sectionStyle.colors.length; i++)
              ColorListTile(
                value: data.sectionStyle.colors[i],
                onChanged: (value) {
                  final colors = List.of(data.sectionStyle.colors);
                  colors[i] = value;

                  _style.add(
                    data.copyWith(
                      sectionStyle: data.sectionStyle.copyWith(
                        colors: colors,
                      ),
                    ),
                  );
                },
                title: Text(
                  'color ${i + 1}',
                ),
              ),
            Button(
              onPressed: () {
                _style.add(
                  data.copyWith(
                    sectionStyle: data.sectionStyle.copyWith(
                      colors: [
                        ...data.sectionStyle.colors,
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
              title: const Text('Add color'),
            ),
          ],
        );
      },
    );
  }
}
