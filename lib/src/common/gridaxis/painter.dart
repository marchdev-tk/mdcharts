// Copyright (c) 2025, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math' as math;

import 'package:flinq/flinq.dart';
import 'package:flutter/rendering.dart';
import 'package:mdcharts/src/_internal.dart';

/// Grid and Axis painter of the [GridAxis].
class GridAxisPainter extends CustomPainter {
  /// Constructs an instance of [GridAxisPainter].
  const GridAxisPainter(
    this.cache,
    this.data,
    this.style,
    this.settings,
    this.onYAxisLabelSizeCalculated,
  );

  /// Cache holder of the GridAxis data that requries heavy computing.
  final GridAxisCacheHolder cache;

  /// Set of required (and optional) data to construct the bar chart.
  final GridAxisData data;

  /// Provides various customizations for the bar chart.
  final GridAxisStyle style;

  /// Provides various settings for the bar chart.
  final GridAxisSettings settings;

  /// Callback that notifies that Y axis label size successfuly calculated.
  final ValueChanged<double> onYAxisLabelSizeCalculated;

  /// {@macro GridAxisUtils.getRoundedDivisionSize}
  double get roundedDivisionSize =>
      GridAxisUtils().getRoundedDivisionSize(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMinValue}
  double get roundedMinValue =>
      GridAxisUtils().getRoundedMinValue(cache, data, settings);

  /// {@macro GridAxisUtils.getRoundedMaxValue}
  double get roundedMaxValue =>
      GridAxisUtils().getRoundedMaxValue(cache, data, settings);

  /// Grid painter.
  void paintGrid(Canvas canvas, Size size) {
    if (settings.xAxisDivisions == 0 && settings.yAxisDivisions == 0) {
      return;
    }

    var maxLabelWidth = .0;

    final xDivisions = settings.xAxisDivisions + 1;
    final widthFraction = size.width / xDivisions;
    final hasLeft = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.horizontal ||
        settings.axisDivisionEdges == AxisDivisionEdges.left;
    final hasRight = settings.axisDivisionEdges == AxisDivisionEdges.all ||
        settings.axisDivisionEdges == AxisDivisionEdges.horizontal ||
        settings.axisDivisionEdges == AxisDivisionEdges.right;
    final xStart = hasLeft ? 0 : 1;
    final xEnd = hasRight ? xDivisions + 1 : xDivisions;
    for (var i = xStart; i < xEnd; i++) {
      canvas.drawLine(
        Offset(widthFraction * i, 0),
        Offset(widthFraction * i, size.height),
        style.gridStyle.xAxisPaint,
      );
    }

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
        style.gridStyle.yAxisPaint,
      );

      /// skip paint of y axis labels if [showAxisYLabels] is set to `true`
      /// or
      /// force to skip last (beneath axis) division paint of axis label.
      if (!settings.showAxisYLabels || hasBottom && i == yEnd - 1) {
        continue;
      }

      double labelValue;
      if (data.data.isEmpty || data.isDefault) {
        labelValue =
            mult(math.max(settings.defaultDivisionInterval, 1), yEnd - i - 1);
      } else if (data.isNegative) {
        labelValue = sub(roundedMaxValue, mult(roundedDivisionSize, i));
      } else {
        labelValue =
            add(roundedMinValue, mult(roundedDivisionSize, yEnd - i - 1));
      }

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
        Offset(0, heightFraction * i + style.gridStyle.yAxisPaint.strokeWidth),
      );
    }

    onYAxisLabelSizeCalculated(maxLabelWidth);
  }

  /// Axis painter.
  void paintAxis(Canvas canvas, Size size) {
    if (!settings.showAxisX && !settings.showAxisY) {
      return;
    }

    final axisPaint = style.axisStyle.paint;

    const topLeft = Offset.zero;
    final bottomLeft = Offset(0, size.height);
    final bottomRight = Offset(size.width, size.height);

    // x axis
    if (settings.showAxisX) {
      canvas.drawLine(bottomLeft, bottomRight, axisPaint);
    }
    // y axis
    if (settings.showAxisY) {
      canvas.drawLine(topLeft, bottomLeft, axisPaint);
    }
  }

  void paintZeroLine(Canvas canvas, Size size) {
    final canPaint =
        style.zeroLineStyle.stroke > 0 && style.zeroLineStyle.color.alpha > 0;
    final minValue = settings.yAxisBaseline == YAxisBaseline.axis
        ? data.minValue
        : data.minValueZeroBased;
    final visible = minValue <= 0 && data.maxValue >= 0;

    if (!settings.showZeroLine || !canPaint || !visible) {
      return;
    }

    final y = GridAxisUtils().normalize(0, cache, data, settings) * size.height;

    canvas.drawLine(
      Offset(0, y),
      Offset(size.width, y),
      style.zeroLineStyle.paint,
    );
  }

  /// Drop line painter.
  static void paintDropLine(
    Canvas canvas,
    Size size,
    GridAxisData data,
    DropLineStyle dropLineStyle,
    Offset point,
  ) {
    if (!data.canDraw) {
      return;
    }

    final dashWidth = dropLineStyle.dashSize;
    final gapWidth = dropLineStyle.gapSize;

    final pathX = Path();
    final pathY = Path();

    pathX.moveTo(0, point.dy);
    pathY.moveTo(point.dx, size.height);

    final countX = (point.dx / (dashWidth + gapWidth)).ceil();
    for (var i = 1; i <= countX; i++) {
      if (i == countX) {
        pathX.lineTo(point.dx, point.dy);
        break;
      }

      pathX.relativeLineTo(dashWidth, 0);
      pathX.relativeMoveTo(gapWidth, 0);
    }

    final countY =
        ((size.height - point.dy) / (dashWidth + gapWidth)).ceil().abs();
    for (var i = 1; i <= countY; i++) {
      if (i == countY) {
        pathY.lineTo(point.dx, point.dy);
        break;
      }

      pathY.relativeLineTo(0, -dashWidth);
      pathY.relativeMoveTo(0, -gapWidth);
    }

    canvas.drawPath(pathX, dropLineStyle.getXAxisPaint(pathX.getBounds()));
    canvas.drawPath(pathY, dropLineStyle.getYAxisPaint(pathY.getBounds()));
  }

  /// Tooltip painter.
  static void paintTooltip<T>(
    Canvas canvas,
    Size size,
    GridAxisData<T> data,
    TooltipStyle tooltipStyle,
    MapEntry<DateTime, T> entry,
    Offset point,
  ) {
    if (!data.canDraw) {
      return;
    }

    final titlePainter = MDTextPainter(TextSpan(
      text: data.titleBuilder(entry.key, entry.value),
      style: tooltipStyle.titleStyle,
    ));
    final subtitlePainter = MDTextPainter(TextSpan(
      text: data.subtitleBuilder(entry.key, entry.value),
      style: tooltipStyle.subtitleStyle,
    ));
    final triangleWidth = tooltipStyle.triangleWidth;
    final triangleHeight = tooltipStyle.triangleHeight;
    final bottomMargin = tooltipStyle.bottomMargin + triangleHeight;
    final titleSize = titlePainter.size;
    final subtitleSize = subtitlePainter.size;
    final spacing = tooltipStyle.spacing;
    final padding = tooltipStyle.padding;
    final contentWidth = math.max(titleSize.width, subtitleSize.width);
    final tooltipSize = Size(
      contentWidth + padding.horizontal,
      titleSize.height + spacing + subtitleSize.height + padding.vertical,
    );
    final radius = Radius.circular(tooltipStyle.radius);
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
      tooltipStyle.shadowColor,
      tooltipStyle.shadowElevation,
      false,
    );
    canvas.drawPath(path, tooltipStyle.paint);

    titlePainter.paint(canvas, titleOffset);
    subtitlePainter.paint(canvas, subtitleOffset);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintGrid(canvas, size);
    paintAxis(canvas, size);
    paintZeroLine(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GridAxisPainter oldDelegate) =>
      cache != oldDelegate.cache ||
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings;
}

/// X axis label painter.
class XAxisLabelPainter extends CustomPainter {
  /// Constructs an instance of [XAxisLabelPainter].
  const XAxisLabelPainter(
    this.data,
    this.style,
    this.settings,
    this.selectedXPosition,
  );

  /// Set of required (and optional) data to construct the grid axis based chart.
  final GridAxisData data;

  /// Provides various customizations for the chart axis.
  final GridAxisStyle style;

  /// Provides various settings for the grid axis based chart.
  final GridAxisSettings settings;

  /// Selected position on the X axis.
  ///
  /// If provided, point with drop line and tooltip will be painted for the nearest point
  /// of the selected position on the X axis. Otherwise, last point will be
  /// painted, but without drop line and tooltip.
  final double? selectedXPosition;

  /// Checks whether chart could be drawned or not.
  bool get canDraw => data.canDraw;

  /// Retrieves data entry index.
  ///
  /// For more info refer to [GridAxisUtils.getSelectedIndex].
  int? getSelectedIndex(Size size) =>
      GridAxisUtils().getSelectedIndex(size, selectedXPosition, data);

  List<int> _getXAxisLabelIndexesToPaint(int? labelQuantity) {
    final length = data.xAxisDates.length;
    final labelStep = labelQuantity != null ? length / (labelQuantity - 1) : .0;
    final halfLabelQty = (labelQuantity ?? 0) ~/ 2;
    final labelQtyIsOdd = (labelQuantity ?? 0) % 2 == 1;
    final steps = [
      for (var i = 0; i < halfLabelQty; i++) ...[
        (i * labelStep).truncate(),
        (length - 1 - (i * labelStep).truncate()),
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
  ) {
    if (!painter.value) {
      return;
    }

    final selectedIndex = getSelectedIndex(size);
    final widthFraction = size.width / data.xAxisDivisions;

    Offset point;
    if (index == 0) {
      point = Offset(widthFraction * index, 0);
    } else if (index == length - 1) {
      point = Offset(widthFraction * index - painter.key.size.width, 0);
    } else {
      point = Offset(widthFraction * index - painter.key.size.width / 2, 0);
    }

    if (index == selectedIndex && settings.showAxisXLabelSelection) {
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
    if (!canDraw) {
      return;
    }

    final dates = data.xAxisDates;
    final steps = _getXAxisLabelIndexesToPaint(settings.xAxisLabelQuantity);
    final painters = <MDTextPainter, bool>{};
    final selectedIndex = getSelectedIndex(size);

    MDTextPainter? selectedPainter;
    for (var i = 0; i < dates.length; i++) {
      final item = dates[i];
      final textStyle = i == selectedIndex && settings.showAxisXLabelSelection
          ? style.axisStyle.xAxisSelectedLabelStyle
          : style.axisStyle.xAxisLabelStyle;
      final text = data.xAxisLabelBuilder(item, textStyle);
      final painter = MDTextPainter(text);
      painters[painter] =
          settings.xAxisLabelQuantity == null ? true : steps.contains(i);
      if (i == selectedIndex) {
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

    for (var i = 0; i < painters.length; i++) {
      final painter = painters.entries.elementAt(i);

      if (i == selectedIndex && settings.showAxisXSelectedLabelIfConcealed) {
        continue;
      }

      _paintLabel(canvas, size, i, painter, dates.length);
    }

    if (selectedPainter != null && settings.showAxisXSelectedLabelIfConcealed) {
      final index = painters.keys.toList().indexOf(selectedPainter);

      _paintLabel(
        canvas,
        size,
        index,
        MapEntry(selectedPainter, true),
        dates.length,
      );
    }
  }

  @override
  bool shouldRepaint(covariant XAxisLabelPainter oldDelegate) =>
      data != oldDelegate.data ||
      style != oldDelegate.style ||
      settings != oldDelegate.settings ||
      selectedXPosition != oldDelegate.selectedXPosition;
}
