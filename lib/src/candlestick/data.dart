// Copyright (c) 2022-2026, the MarchDev Toolkit project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';

import '../_internal.dart';

/// Represents the data for a single candlestick in a financial chart.
class CandlestickData {
  /// Constructs an instance of [CandlestickData].
  const CandlestickData({
    required this.high,
    required this.low,
    required this.bid,
    required this.ask,
  })  : assert(low <= high),
        assert(bid >= low && bid <= high),
        assert(ask >= low && ask <= high);

  const CandlestickData.zero()
      : high = 0,
        low = 0,
        bid = 0,
        ask = 0;

  final double high;
  final double low;

  /// As a `bid`: The highest price a buyer is willing to pay for an asset.
  ///
  /// As a `open`: The price at which an asset starts trading when the market
  /// opens.
  final double bid;

  /// As an `ask`: The lowest price a seller is willing to accept for an asset.
  ///
  /// As a `close`: The price at which an asset stops trading when the market
  /// closes.
  final double ask;

  /// Represents the spread in financial markets.
  ///
  /// The spread is the difference between the bid (highest price a buyer is
  /// willing to pay) and the ask (lowest price a seller is willing to accept)
  /// prices.
  ///
  /// It indicates the transaction cost and liquidity of an asset.
  double get spread => (ask - bid).abs();

  /// Whether there is a data error or an anomaly in the market.
  ///
  /// It could happen only if ask price is less than bid.
  bool get spreadAnomaly => ask - bid < 0;

  /// Represents a bearish market condition.
  ///
  /// A bearish market is characterized by falling prices and a negative
  /// sentiment, where users expect prices to decline.
  bool get isBearish => ask > bid;

  /// Represents a bullish market condition.
  ///
  /// A bullish market is characterized by rising prices and a positive
  /// sentiment, where users expect prices or whateve to increase.
  bool get isBullish => ask <= bid;

  /// Represents a Doji candlestick pattern with shadows.
  ///
  /// This Doji occurs when the open and close prices are equal but the low and
  /// high prices differ, indicating market indecision with significant price
  /// movement.
  bool get isDojiWithShadows => ask == bid && !isDoji;

  /// Represents a Doji candlestick pattern.
  ///
  /// A Doji is formed when the low and high prices are equal, indicating market
  /// indecision.
  bool get isDoji => low == high;

  @override
  String toString() => '{high:$high,low:$low,bid:$bid,ask:$ask}';
}

/// Represents the data for a single candlestick in a financial chart and a
/// currently selected [value].
///
/// It is ONLY needed in [CandlestickChartData.subtitleBuilder] to build
/// subtitle string based on the currently selected value.
///
/// Must be used in a conjunction with [CandlestickChartData.getSelectedValueFromData].
class ValueCandlestickData extends CandlestickData {
  /// Constructs an instance of [ValueCandlestickData].
  const ValueCandlestickData._({
    required super.high,
    required super.low,
    required super.bid,
    required super.ask,
    required this.value,
  });

  /// Constructs an instance of [ValueCandlestickData] from [data] and [value].
  factory ValueCandlestickData.of(CandlestickData data, double value) {
    return ValueCandlestickData._(
      high: data.high,
      low: data.low,
      bid: data.bid,
      ask: data.ask,
      value: value,
    );
  }

  /// Currently selected value of [CandlestickData].
  ///
  /// It could be one of:
  ///  * [CandlestickData.high]
  ///  * [CandlestickData.low]
  ///  * [CandlestickData.bid]
  ///  * [CandlestickData.ask]
  final double value;

  @override
  String toString() => value.toString();
}

/// Data for the [CandlestickChart].
class CandlestickChartData extends GridAxisData<CandlestickData> {
  /// Constructs an instance of [CandlestickChartData].
  const CandlestickChartData({
    required super.data,
    super.predefinedMaxValue,
    super.roundingMap = ChartData.defaultRoundingMap,
    super.xAxisLabelBuilder = GridAxisData.defaultXAxisLabelBuilder,
    super.yAxisLabelBuilder = GridAxisData.defaultYAxisLabelBuilder,
    super.titleBuilder,
    super.subtitleBuilder,
  });

  /// Retrieves currently selected value from [data].
  static double getSelectedValueFromData(CandlestickData data) {
    assert(data is ValueCandlestickData);
    return (data as ValueCandlestickData).value;
  }

  @override
  double maxValuePredicate(CandlestickData value) => value.high;
  @override
  double minValuePredicate(CandlestickData value) => value.low;

  @override
  bool get isDefault =>
      data.values.every((v) => v == const CandlestickData.zero());

  /// Creates a copy of the current object with new values specified in
  /// arguments.
  CandlestickChartData copyWith({
    bool allowNullPredefinedMaxValue = false,
    Map<DateTime, CandlestickData>? data,
    double? predefinedMaxValue,
    Map<String, num>? roundingMap,
    TooltipBuilder? titleBuilder,
    TooltipBuilder? subtitleBuilder,
    RichLabelBuilder<DateTime>? xAxisLabelBuilder,
    LabelBuilder<double>? yAxisLabelBuilder,
  }) =>
      CandlestickChartData(
        data: data ?? this.data,
        predefinedMaxValue: allowNullPredefinedMaxValue
            ? predefinedMaxValue
            : predefinedMaxValue ?? this.predefinedMaxValue,
        roundingMap: roundingMap ?? this.roundingMap,
        titleBuilder: titleBuilder ?? this.titleBuilder,
        subtitleBuilder: subtitleBuilder ?? this.subtitleBuilder,
        xAxisLabelBuilder: xAxisLabelBuilder ?? this.xAxisLabelBuilder,
        yAxisLabelBuilder: yAxisLabelBuilder ?? this.yAxisLabelBuilder,
      );

  @override
  int get hashCode =>
      data.hashCode ^ predefinedMaxValue.hashCode ^ roundingMap.hashCode;

  @override
  bool operator ==(Object other) =>
      other is CandlestickChartData &&
      mapEquals(data, other.data) &&
      predefinedMaxValue == other.predefinedMaxValue &&
      mapEquals(roundingMap, other.roundingMap);
}
