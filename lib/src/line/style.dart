// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/painting.dart';

/// Contains various customization options for the [LineChart].
class LineChartStyle {
  /// Constructs an instance of [LineChartStyle].
  const LineChartStyle({
    this.axisStyle = const LineChartAxisStyle(),
    this.lineStyle = const LineChartLineStyle(),
    this.limitStyle = const LineChartLimitStyle(),
  });

  /// Style of the axis lines.
  final LineChartAxisStyle axisStyle;

  /// Style of the line. It contains customization for the line itself,
  /// color or gradient of the filled part of the chart and final point altitude
  /// line.
  final LineChartLineStyle lineStyle;

  /// Style of the limit label and label dashed line.
  final LineChartLimitStyle limitStyle;
}

/// Contains various customization options for the [LineChart], specifically
/// for the axis of the chart.
class LineChartAxisStyle {
  /// Constructs an instance of [LineChartAxisStyle].
  const LineChartAxisStyle({
    this.stroke = 1,
    this.color = const Color(0x33FFFFFF),
  });

  /// Stroke of the axis lines.
  ///
  /// Defaults to `1`.
  final double stroke;

  /// Color of the axis lines.
  ///
  /// Defaults to `0x33FFFFFF`
  final Color color;

  /// Gets a [Paint] for the axis drawing.
  Paint get paint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = stroke
    ..color = color;
}

/// Contains various customization options for the [LineChart], specifically
/// for the line of the chart itself.
class LineChartLineStyle {
  /// Constructs an instance of [LineChartLineStyle].
  const LineChartLineStyle();

  // TODO
}

/// Contains various customization options for the [LineChart], specifically
/// for limit line and label.
class LineChartLimitStyle {
  /// Constructs an instance of [LineChartLimitStyle].
  const LineChartLimitStyle({
    this.labelStyle = defaultStyle,
    this.labelOveruseStyle = defaultOveruseStyle,
    this.labelTextPadding = defaultTextPadding,
    this.labelColor = const Color(0xFFFFFFFF),
    this.dashColor = const Color(0x80FFFFFF),
    this.dashStroke = 1,
    this.dashSize = 2,
    this.gapSize = 2,
  });

  static const defaultStyle = TextStyle(
    height: 1.33,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFF000000),
  );
  static const defaultOveruseStyle = TextStyle(
    height: 1.33,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFFED2A24),
  );
  static const defaultTextPadding = EdgeInsets.fromLTRB(11, 3, 14, 3);

  /// [TextStyle] of a label.
  ///
  /// Defaults to [defaultStyle].
  final TextStyle labelStyle;

  /// [TextStyle] of a label if limit was overused.
  ///
  /// Defaults to [defaultOveruseStyle].
  final TextStyle labelOveruseStyle;

  /// Padding of a label.
  ///
  /// Defaults to [defaultTextPadding].
  final EdgeInsets labelTextPadding;

  /// Background color of a label.
  ///
  /// Defaults to `0xFFFFFFFF`.
  final Color labelColor;

  /// Color of a dashed line.
  ///
  /// Defaults to `0x80FFFFFF`.
  final Color dashColor;

  /// Stroke of a dash line.
  ///
  /// Defaults to `1`.
  final double dashStroke;

  /// Size of dashes.
  ///
  /// Defaults to `2`.
  final double dashSize;

  /// Gap between dashes.
  ///
  /// Defaults to `2`.
  final double gapSize;

  /// Gets a [Paint] for the limit line drawing.
  Paint get linePaint => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.butt
    ..strokeWidth = dashStroke
    ..color = dashColor;

  /// Gets a [Paint] for the limit label drawing.
  Paint get labelPaint => Paint()
    ..style = PaintingStyle.fill
    ..color = labelColor;
}
