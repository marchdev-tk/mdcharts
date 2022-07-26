// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:mdcharts/mdcharts.dart';
import 'package:rxdart/rxdart.dart';

import 'scaffolds/setup_scaffold.dart';
import 'widgets/color_list_tile.dart';
import 'widgets/dialog_list_tile.dart';
import 'widgets/number_list_tile.dart';

final _settings =
    BehaviorSubject<GaugeChartSettings>.seeded(const GaugeChartSettings());
final _style = BehaviorSubject<GaugeChartStyle>.seeded(const GaugeChartStyle());
final _data = BehaviorSubject<GaugeChartData>.seeded(
    const GaugeChartData(data: [524, 306]));

class GaugeChartExample extends StatelessWidget {
  const GaugeChartExample({Key? key}) : super(key: key);

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
      ],
    );
  }
}

class _Chart extends StatelessWidget {
  const _Chart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GaugeChartSettings>(
      stream: _settings,
      initialData: _settings.value,
      builder: (context, settings) {
        return StreamBuilder<GaugeChartStyle>(
          stream: _style,
          initialData: _style.value,
          builder: (context, style) {
            return StreamBuilder<GaugeChartData>(
              stream: _data,
              initialData: _data.value,
              builder: (context, data) {
                return GaugeChart(
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
    return StreamBuilder<GaugeChartData>(
      stream: _data,
      initialData: _data.value,
      builder: (context, data) {
        return const SetupGroup(
          title: 'General Data',
          children: [],
        );
      },
    );
  }
}

class _GeneralSettingsSetupGroup extends StatelessWidget {
  const _GeneralSettingsSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GaugeChartSettings>(
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
              value: data.gaugeAngle.toInt(),
              onChanged: (value) =>
                  _settings.add(data.copyWith(gaugeAngle: value.toDouble())),
              title: const Text('gaugeAngle'),
            ),
          ],
        );
      },
    );
  }
}

class _BackgroundStyleSetupGroup extends StatelessWidget {
  const _BackgroundStyleSetupGroup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GaugeChartStyle>(
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
              value: data.backgroundStyle.borderColor ?? Colors.transparent,
              onChanged: (value) {
                _style.add(
                  data.copyWith(
                    backgroundStyle: data.backgroundStyle.copyWith(
                      borderColor: value,
                    ),
                  ),
                );
              },
              title: const Text('borderColor'),
            ),
            IntListTile(
              value: data.backgroundStyle.borderStroke.toInt(),
              onChanged: (value) => _style.add(
                data.copyWith(
                  backgroundStyle: data.backgroundStyle.copyWith(
                    borderStroke: value.toDouble(),
                  ),
                ),
              ),
              title: const Text('borderStroke'),
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
