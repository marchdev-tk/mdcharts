// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';
import 'package:rxdart/rxdart.dart';

import 'utils.dart';

/// Main painter of the [BarChart] that paints bars and tooltips.
class BarChartBarPainter extends CustomPainter {
  /// Constructs an instance of [BarChartBarPainter].
  const BarChartBarPainter(
    this.data,
    this.style,
    this.settings,
    this.selectedPeriod,
    this.valueCoef,
    this.dragInProgress,
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

  /// Whether drag in progress or not, this will affect tooltip drawing.
  final bool dragInProgress;

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

  /// {@macro normalizeInverted}
  double normalize(double value) => normalizeInverted(value, roundedMaxValue);

  /// Whether border of the bar could be painted based on the top radius of
  /// the bar and border stroke or not.
  bool canPaintBorder(Size size, DateTime key, int index) {
    final normalizedValue = normalize(data.data[key]![index]);
    final valueHeight =
        normalizedValue * (size.height - style.barStyle.zeroBarHeight);
    final isTooSmall = size.height - valueHeight <
        style.barStyle.borderStroke + style.barStyle.topRadius;

    return !isTooSmall;
  }

  bool get _showTooltip =>
      settings.interaction == InteractionType.overview && dragInProgress;

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

    double getItemWidth(double barWidth) =>
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    var itemWidth = getItemWidth(barWidth);

    if (settings.fit == BarFit.contain) {
      double getChartWidth(double itemWidth, double itemSpacing) =>
          data.data.length * (itemSpacing + itemWidth) - itemSpacing;

      var chartWidth = getChartWidth(itemWidth, itemSpacing);
      final decreaseCoef = itemSpacing / barWidth;

      while (chartWidth > size.width) {
        barWidth -= 1;
        itemSpacing -= decreaseCoef;
        itemWidth = getItemWidth(barWidth);
        chartWidth = getChartWidth(itemWidth, itemSpacing);
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
              size,
              colors,
              selectedColors,
              borderColors,
              selectedBorderColors,
              item.key,
              j,
            ),
        );
        _paintBarBorder(
          canvas,
          size,
          rrect,
          borderColors,
          selectedBorderColors,
          item.key,
          j,
        );
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
              size,
              colors,
              selectedColors,
              borderColors,
              selectedBorderColors,
              item.key,
              j,
            ),
        );
        _paintBarBorder(
          canvas,
          size,
          rrect,
          borderColors,
          selectedBorderColors,
          item.key,
          j,
        );
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
              size,
              colors,
              selectedColors,
              borderColors,
              selectedBorderColors,
              item.key,
              j,
            ),
        );
        _paintBarBorder(
          canvas,
          size,
          rrect,
          borderColors,
          selectedBorderColors,
          item.key,
          j,
        );
      }
    }
  }

  Color _getBarBorderColor(
    List<Color> borderColors,
    List<Color> selectedBorderColors,
    DateTime key,
    int index,
  ) {
    if (key == selectedPeriod.valueOrNull && selectedBorderColors.isNotEmpty) {
      return selectedBorderColors[index];
    } else if (borderColors.isNotEmpty) {
      return borderColors[index];
    } else {
      return const Color(0x00FFFFFF);
    }
  }

  Color _getBarColor(
    Size size,
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
    final paintableBorder = canPaintBorder(size, key, index);

    if ((isZeroBar || !paintableBorder) && !isBorderColorTransparent) {
      return borderColor;
    } else if (key == selectedPeriod.valueOrNull && selectedColors.isNotEmpty) {
      return selectedColors[index];
    } else {
      return colors[index];
    }
  }

  void _paintBarShadow(Canvas canvas, RRect rrect, DateTime key) {
    if (!style.barStyle.canPaintShadow) {
      return;
    }

    final color = key == selectedPeriod.valueOrNull &&
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
    Size size,
    RRect rrect,
    List<Color> borderColors,
    List<Color> selectedBorderColors,
    DateTime key,
    int index,
  ) {
    final isZeroBar = data.data[key]![index] == 0;
    final paintableBorder = canPaintBorder(size, key, index);
    if (!style.barStyle.canPaintBorder || isZeroBar || !paintableBorder) {
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

  Offset _getPoint(Size size, DateTime entryKey, List<double> entryValue) {
    final selectedIndex =
        data.data.entries.toList().indexWhere((e) => e.key == entryKey);

    final barItemQuantity = data.data.values.first.length;
    final barSpacing = settings.barSpacing;

    double getItemWidth(double barWidth) =>
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    var barWidth = style.barStyle.width;
    var itemSpacing = settings.itemSpacing;
    var itemWidth = getItemWidth(barWidth);

    if (settings.fit == BarFit.contain) {
      double getChartWidth(double itemWidth, double itemSpacing) =>
          data.data.length * (itemSpacing + itemWidth) - itemSpacing;

      var chartWidth = getChartWidth(itemWidth, itemSpacing);
      final decreaseCoef = itemSpacing / barWidth;

      while (chartWidth > size.width) {
        barWidth -= 1;
        itemSpacing -= decreaseCoef;
        itemWidth = getItemWidth(barWidth);
        chartWidth = getChartWidth(itemWidth, itemSpacing);
      }
    }

    final barValue = entryValue.max;
    final top = normalize(barValue * valueCoef) *
        (size.height - style.barStyle.zeroBarHeight);
    final itemOffset =
        (itemSpacing + itemWidth) * (data.data.length - 1 - selectedIndex);
    final barRight = size.width - itemOffset;

    return Offset(barRight - itemWidth / 2, top);
  }

  /// Tooltip painter.
  void paintTooltip(Canvas canvas, Size size) {
    if (!data.canDraw || !_showTooltip) {
      return;
    }

    final entryKey = selectedPeriod.value;
    final entryValue = data.data[selectedPeriod.value] ?? [];
    final titlePainter = MDTextPainter(TextSpan(
      text: data.titleBuilder(entryKey, entryValue),
      style: style.tooltipStyle.titleStyle,
    ));
    final subtitlePainter = MDTextPainter(TextSpan(
      text: data.subtitleBuilder(entryKey, entryValue),
      style: style.tooltipStyle.subtitleStyle,
    ));
    final point = _getPoint(size, entryKey, entryValue);
    final triangleWidth = style.tooltipStyle.triangleWidth;
    final triangleHeight = style.tooltipStyle.triangleHeight;
    final bottomMargin = style.tooltipStyle.bottomMargin + triangleHeight;
    final titleSize = titlePainter.size;
    final subtitleSize = subtitlePainter.size;
    final spacing = style.tooltipStyle.spacing;
    final padding = style.tooltipStyle.padding;
    final contentWidth = math.max(titleSize.width, subtitleSize.width);
    final tooltipSize = Size(
      contentWidth + padding.horizontal,
      titleSize.height + spacing + subtitleSize.height + padding.vertical,
    );
    final radius = Radius.circular(style.tooltipStyle.radius);
    final isSelectedIndexFirst = point.dx - tooltipSize.width / 2 < 0;
    final isSelectedIndexLast = point.dx + tooltipSize.width / 2 > size.width;
    final xBias = isSelectedIndexFirst
        ? tooltipSize.width / 2 - triangleWidth / 2 - radius.x
        : isSelectedIndexLast
            ? -tooltipSize.width / 2 + triangleWidth / 2 + radius.x
            : 0;
    final titleOffset = Offset(
      point.dx - titleSize.width / 2 + xBias,
      point.dy -
          bottomMargin -
          padding.bottom -
          subtitleSize.height -
          spacing -
          titleSize.height,
    );
    final subtitleOffset = Offset(
      point.dx - subtitleSize.width / 2 + xBias,
      point.dy - bottomMargin - padding.bottom - subtitleSize.height,
    );
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(
          point.dx + xBias,
          point.dy - bottomMargin - tooltipSize.height / 2,
        ),
        width: tooltipSize.width,
        height: tooltipSize.height,
      ),
      radius,
    );

    final path = Path();
    path.moveTo(point.dx, point.dy - bottomMargin + triangleHeight);
    path.relativeLineTo(-triangleWidth / 2, -triangleHeight);
    path.relativeLineTo(triangleWidth, 0);
    path.relativeLineTo(-triangleWidth / 2, triangleHeight);
    path.close();
    path.addRRect(rrect);

    canvas.drawShadow(
      path,
      style.tooltipStyle.shadowColor,
      style.tooltipStyle.shadowElevation,
      false,
    );
    canvas.drawPath(path, style.tooltipStyle.paint);

    titlePainter.paint(canvas, titleOffset);
    subtitlePainter.paint(canvas, subtitleOffset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBar(canvas, size);
    paintTooltip(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BarChartBarPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// Grid and Axis painter of the [BarChart].
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

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
    paintAxis(canvas, size);
  }

  @override
  bool shouldRepaint(covariant BarChartGridPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// X axis label painter of the [BarChart].
class BarChartXAxisLabelPainter extends CustomPainter {
  /// Constructs an instance of [BarChartBarPainter].
  const BarChartXAxisLabelPainter(
    this.data,
    this.style,
    this.settings,
    this.selectedPeriod,
  );

  /// Set of required (and optional) data to construct the bar chart.
  final BarChartData data;

  /// Provides various customizations for the chart axis.
  final BarChartStyle style;

  /// Provides various settings for the bar chart.
  final BarChartSettings settings;

  /// Selected period value stream.
  final ValueStream<DateTime> selectedPeriod;

  Offset _getItemCenterPoint(Size size, int index) {
    final barItemQuantity = data.data.values.first.length;
    final barSpacing = settings.barSpacing;

    double getItemWidth(double barWidth) =>
        barWidth * barItemQuantity + barSpacing * (barItemQuantity - 1);

    var barWidth = style.barStyle.width;
    var itemSpacing = settings.itemSpacing;
    var itemWidth = getItemWidth(barWidth);

    if (settings.fit == BarFit.contain) {
      double getChartWidth(double itemWidth, double itemSpacing) =>
          data.data.length * (itemSpacing + itemWidth) - itemSpacing;

      var chartWidth = getChartWidth(itemWidth, itemSpacing);
      final decreaseCoef = itemSpacing / barWidth;

      while (chartWidth > size.width) {
        barWidth -= 1;
        itemSpacing -= decreaseCoef;
        itemWidth = getItemWidth(barWidth);
        chartWidth = getChartWidth(itemWidth, itemSpacing);
      }
    }

    switch (settings.alignment) {
      case BarAlignment.start:
        final itemOffset = (itemSpacing + itemWidth) * index;
        final barLeft = barWidth * barItemQuantity +
            barSpacing * (barItemQuantity - 1) +
            itemOffset;
        return Offset(barLeft - itemWidth / 2, 0);
      case BarAlignment.center:
        final itemLength = data.data.length;
        final totalWidth = itemLength * (itemSpacing + itemWidth) - itemSpacing;
        final sideOffset = (size.width - totalWidth) / 2;
        final itemOffset = (itemSpacing + itemWidth) * index + sideOffset;
        final barLeft = barWidth * barItemQuantity +
            barSpacing * (barItemQuantity - 1) +
            itemOffset;
        return Offset(barLeft - itemWidth / 2, 0);
      case BarAlignment.end:
        final itemOffset =
            (itemSpacing + itemWidth) * (data.data.length - 1 - index);
        final barRight = size.width - itemOffset;
        return Offset(barRight - itemWidth / 2, 0);
    }
  }

  Offset _getStartPoint(
    Size size,
    int index,
    int paintersLength,
    double painterWidth,
    double itemSpacing,
  ) {
    var point = _getItemCenterPoint(size, index);

    if (index == 0 &&
        settings.yAxisLayout == YAxisLayout.overlay &&
        point.dx - painterWidth / 2 < 0) {
      point = Offset.zero;
    } else if (index == paintersLength - 1 &&
        point.dx + painterWidth / 2 > size.width) {
      point = Offset(size.width - painterWidth - itemSpacing, 0);
    } else {
      point = point.translate(-painterWidth / 2, 0);
    }

    return point;
  }

  Offset _getCenterPoint(
    Size size,
    int index,
    int paintersLength,
    double painterWidth,
    double itemSpacing,
  ) {
    var point = _getItemCenterPoint(size, index);

    if (index == 0 &&
        settings.yAxisLayout == YAxisLayout.overlay &&
        point.dx - painterWidth / 2 < 0) {
      point = Offset.zero;
    } else if (index == paintersLength - 1 &&
        point.dx + painterWidth / 2 > size.width) {
      point = Offset(size.width - painterWidth, 0);
    } else {
      point = point.translate(-painterWidth / 2, 0);
    }

    return point;
  }

  Offset _getEndPoint(
    Size size,
    int index,
    int paintersLength,
    double painterWidth,
    double itemSpacing,
  ) {
    var point = _getItemCenterPoint(size, index);

    if (index == 0 &&
        settings.yAxisLayout == YAxisLayout.overlay &&
        point.dx - painterWidth / 2 < itemSpacing) {
      point = Offset(0 + itemSpacing, 0);
    } else if (index == paintersLength - 1 &&
        point.dx + painterWidth / 2 > size.width) {
      point = Offset(size.width - painterWidth, 0);
    } else {
      point = point.translate(-painterWidth / 2, 0);
    }

    return point;
  }

  List<int> _getXAxisLabelIndexesToPaint(int? labelQuantity) {
    final length = data.data.length;
    final labelStep = labelQuantity != null ? length / labelQuantity : .0;
    final halfLabelQty = (labelQuantity ?? 0) ~/ 2;
    final labelQtyIsOdd = (labelQuantity ?? 0) % 2 == 1;
    final steps = [
      for (var i = 0; i < halfLabelQty; i++) ...[
        (i * labelStep).round(),
        (length - 1 - (i * labelStep).round()),
      ],
      if (labelQtyIsOdd) length ~/ 2,
    ]..sort();

    return steps;
  }

  void _paintLabel(
    Canvas canvas,
    Size size,
    int index,
    MapEntry<MDTextPainter, bool> painter,
    int length,
    DateTime date,
    BarChartBarMetrics chartMetrics,
  ) {
    if (!painter.value) {
      return;
    }

    Offset point;
    switch (settings.alignment) {
      case BarAlignment.start:
        point = _getStartPoint(
          size,
          index,
          length,
          painter.key.size.width,
          chartMetrics.itemSpacing,
        );
        break;
      case BarAlignment.center:
        point = _getCenterPoint(
          size,
          index,
          length,
          painter.key.size.width,
          chartMetrics.itemSpacing,
        );
        break;
      case BarAlignment.end:
        point = _getEndPoint(
          size,
          index,
          length,
          painter.key.size.width,
          chartMetrics.itemSpacing,
        );
        break;
    }

    if (date == selectedPeriod.value &&
        settings.interaction == InteractionType.selection) {
      canvas.drawRRect(
        style.axisStyle.xAxisSelectedLabelBorderRadius.toRRect(
          Rect.fromLTWH(
            point.dx - style.axisStyle.xAxisLabelPadding.left,
            point.dy,
            painter.key.size.width +
                style.axisStyle.xAxisLabelPadding.horizontal,
            painter.key.size.height +
                style.axisStyle.xAxisLabelPadding.vertical,
          ),
        ),
        Paint()
          ..style = PaintingStyle.fill
          ..isAntiAlias = true
          ..color = style.axisStyle.xAxisSelectedLabelBackgroundColor,
      );
    }
    painter.key.paint(
      canvas,
      point.translate(0, style.axisStyle.xAxisLabelPadding.top),
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (!data.canDraw) {
      return;
    }

    final dates = data.xAxisDates;
    final steps = _getXAxisLabelIndexesToPaint(settings.xAxisLabelQuantity);
    final painters = <MDTextPainter, bool>{};

    MDTextPainter? selectedPainter;
    for (var i = 0; i < dates.length; i++) {
      final item = dates[i];
      final textStyle = item == selectedPeriod.value &&
              settings.interaction == InteractionType.selection
          ? style.axisStyle.xAxisSelectedLabelStyle
          : style.axisStyle.xAxisLabelStyle;
      final text = data.xAxisLabelBuilder(item, textStyle);
      final painter = MDTextPainter(text);
      painters[painter] =
          settings.xAxisLabelQuantity == null ? true : steps.contains(i);
      if (item == selectedPeriod.value) {
        selectedPainter = painter;
      }
    }

    double totalWidth = 0;
    while (true) {
      final visiblePainters =
          painters.entries.where((painter) => painter.value);
      final gapCount = visiblePainters.length - 1;
      totalWidth = visiblePainters
              .map((painter) => painter.key.size.width)
              .sum
              .toDouble() +
          gapCount * style.axisStyle.xAxisLabelPadding.horizontal;

      if (totalWidth > size.width && visiblePainters.length > 3) {
        for (var i = 1; i < visiblePainters.length / 2; i++) {
          final left = visiblePainters.elementAt(i).key;
          final right =
              visiblePainters.elementAt(visiblePainters.length - 1 - i).key;

          painters[left] = false;
          painters[right] = false;
        }

        if (painters.length % 2 == 0) {
          final left = painters.entries.elementAt(painters.length ~/ 2 - 1);
          final right = painters.entries.elementAt(painters.length ~/ 2);

          if (visiblePainters.length > 4) {
            if (left.value && right.value) {
              painters[right.key] = false;
            } else if (!left.value && !right.value) {
              painters[right.key] = true;
            }
          }
        } else {
          final left = painters.entries.elementAt(painters.length ~/ 2 - 1);
          final center = painters.entries.elementAt(painters.length ~/ 2);
          final right = painters.entries.elementAt(painters.length ~/ 2 + 1);

          painters[center.key] = !left.value && !right.value;
        }
      } else {
        break;
      }
    }

    final chartMetrics =
        BarChartUtils().getMetrics(size.width, data, settings, style);
    for (var i = 0; i < painters.length; i++) {
      final painter = painters.entries.elementAt(i);

      if (dates[i] == selectedPeriod.value &&
          settings.showAxisXSelectedLabelIfConcealed) {
        continue;
      }

      _paintLabel(
        canvas,
        size,
        i,
        painter,
        dates.length,
        dates[i],
        chartMetrics,
      );
    }

    if (selectedPainter != null && settings.showAxisXSelectedLabelIfConcealed) {
      final index = painters.keys.toList().indexOf(selectedPainter);

      _paintLabel(
        canvas,
        size,
        index,
        MapEntry(selectedPainter, true),
        dates.length,
        dates[index],
        chartMetrics,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BarChartXAxisLabelPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}
