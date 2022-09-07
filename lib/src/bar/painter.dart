// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:rxdart/rxdart.dart';

import '../common.dart';
import '../utils.dart';
import 'data.dart';
import 'settings.dart';
import 'style.dart';

/// Main painter of the [BarChart].
class BarChartPainter extends CustomPainter {
  /// Constructs an instance of [BarChartPainter].
  const BarChartPainter(
    this.data,
    this.style,
    this.settings,
    this.selectedPeriod,
    this.valueCoef,
  );

  /// Set of required (and optional) data to construct the bar chart.
  final BarChartData data;

  /// Provides various customizations for the bar chart.
  final BarChartStyle style;

  /// Provides various settings for the bar chart.
  final BarChartSettings settings;

  /// Selected period value stream.
  final ValueStream<DateTime> selectedPeriod;

  /// Multiplication coeficient of the value. It is used to create chart
  /// animation.
  final double valueCoef;

  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with "beautiful" integer chunks.
  ///
  /// Example:
  /// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
  /// - maxValue = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  double get roundedMaxValue => getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );

  /// Normalization method.
  ///
  /// Converts provided [value] based on [roundedMaxValue] into a percentage
  /// proportion with valid values in inclusive range [0..1].
  ///
  /// Returns `1 - result`, where `result` was calculated in the previously
  /// metioned step.
  double normalize(double value) {
    final normalizedValue = 1 - value / roundedMaxValue;
    return normalizedValue.isNaN ? 0 : normalizedValue;
  }

  /// Axis painter.
  void paintAxis(Canvas canvas, Size size) {
    if (!settings.showAxisX) {
      return;
    }

    final axisPaint = style.axisStyle.paint;
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    canvas.drawLine(bottomLeft, bottomRight, axisPaint);
  }

  /// Bar painter.
  void paintBar(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    final barTopRadius = Radius.circular(style.barStyle.topRadius);
    final zeroBarTopRadius = Radius.circular(style.barStyle.zeroBarTopRadius);

    final barItemQuantity = data.data.values.first.length;
    final barSpacing = settings.barSpacing;
    var barWidth = style.barStyle.width;
    var itemSpacing = settings.itemSpacing;

    double _getItemWidth(double barWidth) =>
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    var itemWidth = _getItemWidth(barWidth);

    if (settings.fit == BarFit.contain) {
      double _getChartWidth(double itemWidth, double itemSpacing) =>
          data.data.length * (itemSpacing + itemWidth) - itemSpacing;

      var chartWidth = _getChartWidth(itemWidth, itemSpacing);
      final decreaseCoef = itemSpacing / barWidth;

      while (chartWidth > size.width) {
        barWidth -= 1;
        itemSpacing -= decreaseCoef;
        itemWidth = _getItemWidth(barWidth);
        chartWidth = _getChartWidth(itemWidth, itemSpacing);
      }
    }

    final colors = List.of(style.barStyle.colors);
    final selectedColors = List.of(style.barStyle.selectedColors ?? <Color>[]);
    final borderColors = List.of(style.barStyle.borderColors ?? <Color>[]);
    final selectedBorderColors =
        List.of(style.barStyle.selectedBorderColors ?? <Color>[]);

    assert(
      colors.length == 1 || colors.length == barItemQuantity,
      'List of colors must contain either 1 color or quantity that is equal to '
      'bar quantity in an item',
    );
    if (colors.length == 1 && barItemQuantity > 1) {
      colors.add(colors.first
          .withOpacity((barItemQuantity - 1) * 1 / barItemQuantity));
    }
    assert(
      selectedColors.isEmpty ||
          selectedColors.length == 1 ||
          selectedColors.length == barItemQuantity,
      'List of selected colors must be empty or contain either 1 color or '
      'quantity that is equal to bar quantity in an item',
    );
    if (selectedColors.length == 1 && barItemQuantity > 1) {
      selectedColors.add(selectedColors.first
          .withOpacity((barItemQuantity - 1) * 1 / barItemQuantity));
    }
    assert(
      borderColors.isEmpty ||
          borderColors.length == 1 ||
          borderColors.length == barItemQuantity,
      'List of border colors must be empty or contain either 1 color or '
      'quantity that is equal to bar quantity in an item',
    );
    if (borderColors.length == 1 && barItemQuantity > 1) {
      borderColors.add(borderColors.first
          .withOpacity((barItemQuantity - 1) * 1 / barItemQuantity));
    }
    assert(
      selectedBorderColors.isEmpty ||
          selectedBorderColors.length == 1 ||
          selectedBorderColors.length == barItemQuantity,
      'List of selected border colors must be empty or contain either 1 color '
      'or quantity that is equal to bar quantity in an item',
    );
    if (selectedBorderColors.length == 1 && barItemQuantity > 1) {
      selectedBorderColors.add(selectedBorderColors.first
          .withOpacity((barItemQuantity - 1) * 1 / barItemQuantity));
    }

    switch (settings.alignment) {
      case BarAlignment.start:
        _paintBarStart(
          canvas,
          size,
          barTopRadius,
          zeroBarTopRadius,
          itemSpacing,
          itemWidth,
          barSpacing,
          barWidth,
          colors,
          selectedColors,
          borderColors,
          selectedBorderColors,
        );
        break;

      case BarAlignment.center:
        _paintBarCenter(
          canvas,
          size,
          barTopRadius,
          zeroBarTopRadius,
          itemSpacing,
          itemWidth,
          barSpacing,
          barWidth,
          colors,
          selectedColors,
          borderColors,
          selectedBorderColors,
        );
        break;

      case BarAlignment.end:
        _paintBarEnd(
          canvas,
          size,
          barTopRadius,
          zeroBarTopRadius,
          itemSpacing,
          itemWidth,
          barSpacing,
          barWidth,
          colors,
          selectedColors,
          borderColors,
          selectedBorderColors,
        );
        break;
    }
  }

  void _paintBarStart(
    Canvas canvas,
    Size size,
    Radius barTopRadius,
    Radius zeroBarTopRadius,
    double itemSpacing,
    double itemWidth,
    double barSpacing,
    double barWidth,
    List<Color> colors,
    List<Color> selectedColors,
    List<Color> borderColors,
    List<Color> selectedBorderColors,
  ) {
    for (var i = 0; i < data.data.length; i++) {
      final item = data.data.entries.elementAt(i);

      for (var j = item.value.length - 1; j >= 0; j--) {
        final barValue = item.value[j];

        final radius = style.barStyle.showZeroBars && barValue == 0
            ? zeroBarTopRadius
            : barTopRadius;
        final top = normalize(barValue * valueCoef) *
            (size.height - style.barStyle.zeroBarHeight);

        final itemOffset = (itemSpacing + itemWidth) * i;

        final barLeft = barWidth * j + barSpacing * j + itemOffset;
        final barRight = barWidth + barLeft;

        final rrect = RRect.fromLTRBAndCorners(
          barLeft,
          top,
          barRight,
          size.height,
          topLeft: radius,
          topRight: radius,
        );

        _paintBarShadow(canvas, rrect, item.key);
        canvas.drawRRect(
          rrect,
          style.barStyle.barPaint
            ..color = _getBarColor(
              colors,
              selectedColors,
              borderColors,
              selectedBorderColors,
              item.key,
              j,
            ),
        );
        _paintBarBorder(
            canvas, rrect, borderColors, selectedBorderColors, item.key, j);
      }
    }
  }

  void _paintBarCenter(
    Canvas canvas,
    Size size,
    Radius barTopRadius,
    Radius zeroBarTopRadius,
    double itemSpacing,
    double itemWidth,
    double barSpacing,
    double barWidth,
    List<Color> colors,
    List<Color> selectedColors,
    List<Color> borderColors,
    List<Color> selectedBorderColors,
  ) {
    for (var i = 0; i < data.data.length; i++) {
      final item = data.data.entries.elementAt(i);

      for (var j = item.value.length - 1; j >= 0; j--) {
        final barValue = item.value[j];

        final radius = style.barStyle.showZeroBars && barValue == 0
            ? zeroBarTopRadius
            : barTopRadius;
        final top = normalize(barValue * valueCoef) *
            (size.height - style.barStyle.zeroBarHeight);

        final itemLength = data.data.length;
        final totalWidth = itemLength * (itemSpacing + itemWidth) - itemSpacing;
        final sideOffset = (size.width - totalWidth) / 2;

        final itemOffset = (itemSpacing + itemWidth) * i + sideOffset;

        final barLeft = barWidth * j + barSpacing * j + itemOffset;
        final barRight = barWidth + barLeft;

        final rrect = RRect.fromLTRBAndCorners(
          barLeft,
          top,
          barRight,
          size.height,
          topLeft: radius,
          topRight: radius,
        );

        _paintBarShadow(canvas, rrect, item.key);
        canvas.drawRRect(
          rrect,
          style.barStyle.barPaint
            ..color = _getBarColor(
              colors,
              selectedColors,
              borderColors,
              selectedBorderColors,
              item.key,
              j,
            ),
        );
        _paintBarBorder(
            canvas, rrect, borderColors, selectedBorderColors, item.key, j);
      }
    }
  }

  void _paintBarEnd(
    Canvas canvas,
    Size size,
    Radius barTopRadius,
    Radius zeroBarTopRadius,
    double itemSpacing,
    double itemWidth,
    double barSpacing,
    double barWidth,
    List<Color> colors,
    List<Color> selectedColors,
    List<Color> borderColors,
    List<Color> selectedBorderColors,
  ) {
    for (var i = data.data.length - 1; i >= 0; i--) {
      final item = data.data.entries.elementAt(i);

      for (var j = item.value.length - 1; j >= 0; j--) {
        final barValue = item.value[j];

        final radius = style.barStyle.showZeroBars && barValue == 0
            ? zeroBarTopRadius
            : barTopRadius;
        final top = normalize(barValue * valueCoef) *
            (size.height - style.barStyle.zeroBarHeight);

        final itemOffset =
            (itemSpacing + itemWidth) * (data.data.length - 1 - i);

        final barRight = size.width -
            barWidth * (item.value.length - 1 - j) -
            barSpacing * (item.value.length - 1 - j) -
            itemOffset;
        final barLeft = barRight - barWidth;

        final rrect = RRect.fromLTRBAndCorners(
          barLeft,
          top,
          barRight,
          size.height,
          topLeft: radius,
          topRight: radius,
        );

        _paintBarShadow(canvas, rrect, item.key);
        canvas.drawRRect(
          rrect,
          style.barStyle.barPaint
            ..color = _getBarColor(
              colors,
              selectedColors,
              borderColors,
              selectedBorderColors,
              item.key,
              j,
            ),
        );
        _paintBarBorder(
            canvas, rrect, borderColors, selectedBorderColors, item.key, j);
      }
    }
  }

  Color _getBarBorderColor(
    List<Color> borderColors,
    List<Color> selectedBorderColors,
    DateTime key,
    int index,
  ) {
    if (key == selectedPeriod.value && selectedBorderColors.isNotEmpty) {
      return selectedBorderColors[index];
    } else if (borderColors.isNotEmpty) {
      return borderColors[index];
    } else {
      return const Color(0x00FFFFFF);
    }
  }

  Color _getBarColor(
    List<Color> colors,
    List<Color> selectedColors,
    List<Color> borderColors,
    List<Color> selectedBorderColors,
    DateTime key,
    int index,
  ) {
    final borderColor = _getBarBorderColor(
      borderColors,
      selectedBorderColors,
      key,
      index,
    );
    final isBorderColorTransparent = borderColor.alpha == 0;
    final isZeroBar = data.data[key]![index] == 0;

    if (isZeroBar && !isBorderColorTransparent) {
      return borderColor;
    } else if (key == selectedPeriod.value && selectedColors.isNotEmpty) {
      return selectedColors[index];
    } else {
      return colors[index];
    }
  }

  void _paintBarShadow(Canvas canvas, RRect rrect, DateTime key) {
    if (!style.barStyle.canPaintShadow) {
      return;
    }

    final color = key == selectedPeriod.value &&
            style.barStyle.selectedShadowColor != null
        ? style.barStyle.selectedShadowColor!
        : style.barStyle.shadowColor ?? const Color(0x00FFFFFF);

    final path = Path();
    path.addRRect(rrect);
    canvas.drawShadow(
      path,
      color,
      style.barStyle.shadowElevation,
      true,
    );
  }

  void _paintBarBorder(
    Canvas canvas,
    RRect rrect,
    List<Color> borderColors,
    List<Color> selectedBorderColors,
    DateTime key,
    int index,
  ) {
    if (!style.barStyle.canPaintBorder || data.data[key]![index] == 0) {
      return;
    }

    final color = _getBarBorderColor(
      borderColors,
      selectedBorderColors,
      key,
      index,
    );

    final barStyle = style.barStyle;
    final strokeBias = barStyle.borderStroke / 2;
    final topRadius = data.data[key]![index] == 0
        ? barStyle.zeroBarTopRadius
        : barStyle.topRadius;

    void drawLeft() {
      canvas.drawLine(
        Offset(rrect.left + strokeBias, rrect.top + topRadius),
        Offset(rrect.left + strokeBias, rrect.bottom),
        barStyle.barBorderPaint..color = color,
      );
    }

    void drawTop() {
      if (barStyle.width / 2 == topRadius) {
        canvas.drawArc(
          Rect.fromLTWH(
            rrect.left + strokeBias,
            rrect.top + strokeBias,
            barStyle.width - barStyle.borderStroke,
            barStyle.width - barStyle.borderStroke,
          ),
          0,
          -math.pi,
          false,
          barStyle.barBorderPaint..color = color,
        );
      } else {
        final path = Path();
        path.arcTo(
          Rect.fromLTWH(
            rrect.left + strokeBias,
            rrect.top + strokeBias,
            topRadius * 2 - barStyle.borderStroke,
            topRadius * 2 - barStyle.borderStroke,
          ),
          math.pi,
          math.pi / 2,
          false,
        );
        path.relativeLineTo(
          barStyle.width - topRadius * 2,
          0,
        );
        path.addArc(
          Rect.fromLTWH(
            rrect.right + strokeBias - topRadius * 2,
            rrect.top + strokeBias,
            topRadius * 2 - barStyle.borderStroke,
            topRadius * 2 - barStyle.borderStroke,
          ),
          0,
          -math.pi / 2,
        );
        canvas.drawPath(
          path,
          barStyle.barBorderPaint..color = color,
        );
      }
    }

    void drawRight() {
      canvas.drawLine(
        Offset(rrect.right - strokeBias, rrect.top + topRadius),
        Offset(rrect.right - strokeBias, rrect.bottom),
        barStyle.barBorderPaint..color = color,
      );
    }

    void drawBottom() {
      canvas.drawLine(
        Offset(rrect.left, rrect.bottom - strokeBias),
        Offset(rrect.right, rrect.bottom - strokeBias),
        barStyle.barBorderPaint..color = color,
      );
    }

    void drawAll() {
      canvas.drawRRect(
        RRect.fromLTRBAndCorners(
          rrect.left + strokeBias,
          rrect.top + strokeBias,
          rrect.right - strokeBias,
          rrect.bottom - strokeBias,
          topLeft: rrect.tlRadius,
          topRight: rrect.trRadius,
        ),
        barStyle.barBorderPaint..color = color,
      );
    }

    switch (barStyle.border) {
      case BarBorder.left:
        drawLeft();
        break;
      case BarBorder.top:
        drawTop();
        break;
      case BarBorder.right:
        drawRight();
        break;
      case BarBorder.bottom:
        drawBottom();
        break;
      case BarBorder.horizontal:
        drawLeft();
        drawRight();
        break;
      case BarBorder.vertical:
        drawTop();
        drawBottom();
        break;
      case BarBorder.all:
        drawAll();
        break;

      case BarBorder.none:
      default:
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintAxis(canvas, size);
    paintBar(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// Grid painter of the [BarChart].
class BarChartGridPainter extends CustomPainter {
  /// Constructs an instance of [BarChartGridPainter].
  const BarChartGridPainter(
    this.data,
    this.style,
    this.settings,
    this.onYAxisLabelSizeCalculated,
  );

  /// Set of required (and optional) data to construct the bar chart.
  final BarChartData data;

  /// Provides various customizations for the bar chart.
  final BarChartStyle style;

  /// Provides various settings for the bar chart.
  final BarChartSettings settings;

  /// Callback that notifies that Y axis label size successfuly calculated.
  final ValueChanged<double> onYAxisLabelSizeCalculated;

  /// Rounding method that rounds [data.maxValue] so, it could be divided by
  /// [settings.yAxisDivisions] with "beautiful" integer chunks.
  ///
  /// Example:
  /// - yAxisDivisions = 2 (so 2 division lines results with 3 chunks of chart);
  /// - maxValue = 83 (from data).
  ///
  /// So, based on these values maxValue will be rounded to `90`.
  double get roundedMaxValue => getRoundedMaxValue(
        data.maxValueRoundingMap,
        data.maxValue,
        settings.yAxisDivisions,
      );

  /// Grid painter.
  void paintGrid(Canvas canvas, Size size) {
    if (settings.yAxisDivisions == 0) {
      return;
    }

    var maxLabelWidth = .0;
    final yDivisions = settings.yAxisDivisions + 1;
    final heightFraction = size.height / yDivisions;
    final hasTop = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.vertical ||
        settings.axisDivisionEdges == AxisDivisionEdges.top;
    final hasBottom = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.vertical ||
        settings.axisDivisionEdges == AxisDivisionEdges.bottom;
    final yStart = hasTop ? 0 : 1;
    final yEnd = hasBottom ? yDivisions + 1 : yDivisions;
    for (var i = yStart; i < yEnd; i++) {
      canvas.drawLine(
        Offset(0, heightFraction * i),
        Offset(size.width, heightFraction * i),
        style.gridStyle.paint,
      );

      /// skip paint of y axis labels if [showAxisYLabels] is set to `true`
      /// or
      /// force to skip last (beneath axis) division paint of axis label.
      if (!settings.showAxisYLabels || hasBottom && i == yEnd - 1) {
        continue;
      }

      final labelValue = roundedMaxValue * (yDivisions - i) / yDivisions;
      final textPainter = MDTextPainter(
        TextSpan(
          text: data.yAxisLabelBuilder(labelValue),
          style: style.axisStyle.yAxisLabelStyle,
        ),
      );

      if (settings.yAxisLayout == YAxisLayout.displace &&
          maxLabelWidth < textPainter.size.width) {
        maxLabelWidth = textPainter.size.width;
      }

      textPainter.paint(
        canvas,
        Offset(0, heightFraction * i + style.gridStyle.paint.strokeWidth),
      );
    }

    onYAxisLabelSizeCalculated(maxLabelWidth);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BarChartGridPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}
