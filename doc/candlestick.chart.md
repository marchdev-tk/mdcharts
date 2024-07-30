# CandlestickChart

## Data

* ### REQUIRED data

  * `data` - set of data with `DateTime` keys and `CandlestickData` values based on which chart will be drawned.
    Where `CandlestickData` contains following fields:
      * `high` - highest value for the period.
      * `low` - lowest value for the period.
      * `bid` - opening value for the period, if it is greater then `ask` than candle will be considered as bullish, otherwise - bearish.
      * `ask` - closing value for the period, if it is less then `bid` than candle will be considered as bullish, otherwise - bearish.

* ### Max Value 

  * `predefinedMaxValue` - predefined max value for the chart.
  * `maxValueRoundingMap` - rounding map for the maxValue that is used by beautification function of Y axis labels.

* ### Tooltip builders

  * `titleBuilder` - builds title of the tooltip based on `DateTime` key and/or `double` value from provided data.
  * `subtitleBuilder` - builds subtitle of the tooltip based on `DateTime` key and/or `double` value from provided data.

* ### Label builder

  * `xAxisLabelBuilder` - builds X axis label based on `DateTime` value from provided data.
  * `yAxisLabelBuilder` - builds Y axis label based on `double` value from provided data, `maxValue` specifically.

## Settings

* `xAxisDivisions` - quantity of the X axis divisions, defaults to `3`.
* `yAxisDivisions` - quantity of the Y axis divisions, defaults to `2`.
* `xAxisLabelQuantity` - quantity of the X axis labels to draw, defaults to `null`.
* `axisDivisionEdges` - axis division edges, defaults to `AxisDivisionEdges.none`.
* `showAxisX` - whether to show X axis or not, defaults to `true`.
* `showAxisXSelectedLabelIfConcealed` - whether to show selected label if it is concealed by `xAxisLabelQuantity`, defaults to `false`.
* `showAxisY` - whether to show Y axis or not, defaults to `true`.
* `showAxisXLabels` - whether to show labels on the X axis or not, defaults to `true`.
* `showAxisYLabels` - whether to show labels on the Y axis or not, defaults to `true`.
* `showAxisXLabelSelection` - whether to paint with selected style currently selected X axis label or not, defaults to `false`.
* `yAxisLayout` - layout type of the Y axis labels, defaults to `YAxisLayout.overlay`.
* `yAxisBaseline` - baseline of the Y axis label values, defaults to `YAxisBaseline.zero`.
* `yAxisLabelSpacing` - spacing between the Y axis labels and chart itself, defaults to `0`.
* `showZeroLine` - whether to show zero line or not, defaults to `false`.
* `showDropLine` - whether to show drop line or not, defaults to `true`.
* `showTooltip` - whether to show tooltip or not, defaults to `true`.
* `selectionEnabled` - whether selection enabled or not, defaults to `true`.

#### Styles

* `gridStyle` - styling options for grid, for more details please refer to the source code of the `GridStyle`.
* `axisStyle` - styling options for axis, for more details please refer to the source code of the `AxisStyle`.
* `zeroLineStyle` - styling options for zero line, for more details please refer to the source code of the `ZeroLineStyle`.
* `dropLineStyle` - styling options for drop line, for more details please refer to the source code of the `DropLineStyle`.
* `candleStickStyle` - styling options for candle and stick, for more details please refer to the source code of the `CandlestickChartCandleStickStyle`.
* `tooltipStyle` - styling options for tooltip, for more details please refer to the source code of the `TooltipStyle`.
