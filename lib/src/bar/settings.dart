// Copyright (c) 2022, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../common.dart';

/// Alignment of the bars within chart.
///
/// Note that alignment will be used only if total bar width is less the paint
/// zone (if no scroll is present).
enum BarAlignment {
  /// Bars will be placed at the start (left side) of the chart zone.
  start,

  /// Bars will be placed at the center of the chart zone.
  center,

  /// Bars will be placed at the end (right side) of the chart zone.
  end,
}

/// How the bars should be inscribed into painting zone.
enum BarFit {
  /// Align the bars within the target scrollable box.
  ///
  /// Bars will not be resized.
  ///
  /// This is default option.
  none,

  /// As large as possible while still containing the bars within the
  /// target box.
  contain,
}

/// How one will be interacting with the [BarChart].
enum InteractionType {
  /// Bar could be selected by tap.
  ///
  /// This is default option.
  selection,

  /// Always last bar is selected, but previous could be overviewed by long
  /// pressing LMB or touch screen.
  overview,

  /// No interactions available.
  none,
}

/// Set of settings of the [BarChart].
class BarChartSettings {
  /// Constructs an instance of [BarChartSettings].
  const BarChartSettings({
    this.yAxisDivisions = 2,
    this.xAxisLabelQuantity,
    this.axisDivisionEdges = AxisDivisionEdges.none,
    this.showAxisX = true,
    this.showAxisXLabels = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisYLabels = true,
    this.yAxisLayout = YAxisLayout.overlay,
    this.yAxisLabelSpacing = 0,
    this.barSpacing = 0,
    this.itemSpacing = 12,
    this.interaction = InteractionType.selection,
    this.duration = const Duration(milliseconds: 400),
    this.alignment = BarAlignment.end,
    this.reverse = false,
    this.fit = BarFit.none,
  });

  /// Constructs an instance of [BarChartSettings] without grids.
  const BarChartSettings.gridless({
    this.xAxisLabelQuantity,
    this.showAxisX = true,
    this.showAxisXLabels = true,
    this.showAxisXSelectedLabelIfConcealed = false,
    this.showAxisYLabels = true,
    this.yAxisLayout = YAxisLayout.overlay,
    this.yAxisLabelSpacing = 0,
    this.barSpacing = 0,
    this.itemSpacing = 12,
    this.interaction = InteractionType.selection,
    this.duration = const Duration(milliseconds: 400),
    this.alignment = BarAlignment.end,
    this.reverse = false,
    this.fit = BarFit.none,
  })  : yAxisDivisions = 0,
        axisDivisionEdges = AxisDivisionEdges.none;

  /// Divisions of the Y axis or the quantity of the grid lines on Y axis.
  ///
  /// Defaults to `2` for basic constructor.
  ///
  /// **Note**: to prevent from displaying only Y axis - set
  /// [xAxisDivisions] to `0`, so Y axis will not be painted, but X axis will.
  ///
  /// **Also Note**: to prevent from displaying entire grid set both
  /// [xAxisDivisions] and [yAxisDivisions] to `0` or consider using
  /// [BarChartSettings.gridless] constructor.
  final int yAxisDivisions;

  /// Quantity of the X axis labels to draw.
  ///
  /// Defaults to `null`.
  ///
  /// If X axis label quantity is set - it could be less than or equal to a
  /// specified value, but no less than `2`.
  ///
  /// **Note**: that X axis labels are dynamically displaying beneath X axis
  /// based on width that they occupy and available drawing space.
  ///
  /// **Also Note**: that this setting is working only in a conjunction with
  /// [BarFit.contain].
  final int? xAxisLabelQuantity;

  /// Axis division edges to be painted.
  ///
  /// Defaults to [AxisDivisionEdges.none].
  final AxisDivisionEdges axisDivisionEdges;

  /// Whether to show X axis or not.
  ///
  /// Defaults to `true`.
  final bool showAxisX;

  /// Whether to show X axis labels or not.
  ///
  /// Defaults to `true`.
  final bool showAxisXLabels;

  /// Whether to show X axis labels or not if [xAxisLabelQuantity] is set and
  /// label is concealed in normal circumstances.
  ///
  /// Defaults to `false`.
  final bool showAxisXSelectedLabelIfConcealed;

  /// Whether to show Y axis labels or not.
  ///
  /// Defaults to `true`.
  final bool showAxisYLabels;

  /// Layout type of the Y axis labels.
  ///
  /// Defaults to [YAxisLayout.overlay].
  final YAxisLayout yAxisLayout;

  /// Spacing between the Y axis labels and chart itself.
  ///
  /// **Please note**, that this setting affects spacing only in case of
  /// [yAxisLayout] is set to [YAxisLayout.displace], otherwise it does nothing.
  ///
  /// Defaults to `0`.
  final double yAxisLabelSpacing;

  /// Spacing between bars in one item.
  ///
  /// If positive value is set - bars will be painted with a given indent.
  /// If negative value is set - bars will be painted with overlapping on each
  /// other with a given indent.
  ///
  /// Defaults to `0`.
  final double barSpacing;

  /// Spacing between group of bars.
  ///
  /// Defaults to `12`.
  final double itemSpacing;

  /// How to interact with the [BarChart].
  ///
  /// **Please note**, that [InteractionType.overview] would work only in a
  /// conjunction with [BarFit.contain] as of gesture distinction conflict
  /// between Scrollable and GestureDetector.
  ///
  /// Defaults to [InteractionType.selection].
  final InteractionType interaction;

  /// The length of time animation should last.
  ///
  /// To disable animation - [Duration.zero] could be passed.
  final Duration duration;

  /// Alignment of the bars within chart.
  ///
  /// Defaults to [BarAlignment.end].
  ///
  /// Note that alignment will be used only if total bar width is less the paint
  /// zone (if no scroll is present).
  final BarAlignment alignment;

  /// Whether the scroll view scrolls in the reading direction.
  ///
  /// For example, if the reading direction is left-to-right, then the scroll
  /// view scrolls from left to right when [reverse] is `false` and from right
  /// to left when [reverse] is `true`.
  ///
  /// Defaults to `false`.
  final bool reverse;

  /// Insription type of the bars within target box (painting zone).
  ///
  /// Defaults to [BarFit.none].
  final BarFit fit;

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  BarChartSettings copyWith({
    bool allowNullXAxisLabelQuantity = false,
    int? yAxisDivisions,
    int? xAxisLabelQuantity,
    AxisDivisionEdges? axisDivisionEdges,
    bool? showAxisX,
    bool? showAxisXLabels,
    bool? showAxisXSelectedLabelIfConcealed,
    bool? showAxisYLabels,
    YAxisLayout? yAxisLayout,
    double? yAxisLabelSpacing,
    double? barSpacing,
    double? itemSpacing,
    InteractionType? interaction,
    Duration? duration,
    BarAlignment? alignment,
    bool? reverse,
    BarFit? fit,
  }) =>
      BarChartSettings(
        yAxisDivisions: yAxisDivisions ?? this.yAxisDivisions,
        xAxisLabelQuantity: allowNullXAxisLabelQuantity
            ? xAxisLabelQuantity
            : xAxisLabelQuantity ?? this.xAxisLabelQuantity,
        axisDivisionEdges: axisDivisionEdges ?? this.axisDivisionEdges,
        showAxisX: showAxisX ?? this.showAxisX,
        showAxisXLabels: showAxisXLabels ?? this.showAxisXLabels,
        showAxisXSelectedLabelIfConcealed: showAxisXSelectedLabelIfConcealed ??
            this.showAxisXSelectedLabelIfConcealed,
        showAxisYLabels: showAxisYLabels ?? this.showAxisYLabels,
        yAxisLayout: yAxisLayout ?? this.yAxisLayout,
        yAxisLabelSpacing: yAxisLabelSpacing ?? this.yAxisLabelSpacing,
        barSpacing: barSpacing ?? this.barSpacing,
        itemSpacing: itemSpacing ?? this.itemSpacing,
        interaction: interaction ?? this.interaction,
        duration: duration ?? this.duration,
        alignment: alignment ?? this.alignment,
        reverse: reverse ?? this.reverse,
        fit: fit ?? this.fit,
      );

  @override
  int get hashCode =>
      yAxisDivisions.hashCode ^
      xAxisLabelQuantity.hashCode ^
      axisDivisionEdges.hashCode ^
      showAxisX.hashCode ^
      showAxisXLabels.hashCode ^
      showAxisXSelectedLabelIfConcealed.hashCode ^
      showAxisYLabels.hashCode ^
      yAxisLayout.hashCode ^
      yAxisLabelSpacing.hashCode ^
      barSpacing.hashCode ^
      itemSpacing.hashCode ^
      interaction.hashCode ^
      duration.hashCode ^
      alignment.hashCode ^
      reverse.hashCode ^
      fit.hashCode;

  @override
  bool operator ==(Object other) =>
      other is BarChartSettings &&
      yAxisDivisions == other.yAxisDivisions &&
      xAxisLabelQuantity == other.xAxisLabelQuantity &&
      axisDivisionEdges == other.axisDivisionEdges &&
      showAxisX == other.showAxisX &&
      showAxisXLabels == other.showAxisXLabels &&
      showAxisXSelectedLabelIfConcealed ==
          other.showAxisXSelectedLabelIfConcealed &&
      showAxisYLabels == other.showAxisYLabels &&
      yAxisLayout == other.yAxisLayout &&
      yAxisLabelSpacing == other.yAxisLabelSpacing &&
      barSpacing == other.barSpacing &&
      itemSpacing == other.itemSpacing &&
      interaction == other.interaction &&
      duration == other.duration &&
      alignment == other.alignment &&
      reverse == other.reverse &&
      fit == other.fit;
}
