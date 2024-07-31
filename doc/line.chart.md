# LineChart

## Data

* ### REQUIRED data

  * `data` - set of data with `DateTime` keys and `double` values based on which chart will be drawned.

* ### There are 2 general types of the `LineChart`:

  * **`Periodical` grid type (only `monthly` available for now):**
    Periodical means that if there's not enough data to draw full chart (there's gaps between dates) chart will automatically fulfill lacking data.

  * **`Undefined` grid type:**
    Undefined means that the chart will be drawned using only provided data.

* ### Max Value 

  * `predefinedMaxValue` - predefined max value for the chart.
  * `roundingMap` - rounding map that is used by beautification function of Y axis labels.

* ### Limits

  * `limit` - if provided, will be painted on the chart as a horizontal indication line.
  * `limitText` - custom text to set to the label of the limit line.

  Note that if `limitText` is set without provided `limit`, there will be no limit line.

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
* `lineFilling` - whether to fill chart between the line and the X axis or not, defaults to `true`.
* `lineShadow` - whether to draw shadow beneath the line or not, defaults to `true`.
* `altitudeLine` - whether to draw the altitude line or not, defaults to `true`.
* `limitLabelSnapPosition` - snap position options of limit label, defaults to `LimitLabelSnapPosition.axis`.
* `showPoint` - whether to show point or not, defaults to `true`.
* `selectionEnabled` - whether selection enabled or not, defaults to `true`.
* `startLineFromZero` - whether to start the line from zero point or not, defaults to `true`.

#### Styles

* `gridStyle` - styling options for grid, for more details please refer to the source code of the `GridStyle`.
* `axisStyle` - styling options for axis, for more details please refer to the source code of the `AxisStyle`.
* `zeroLineStyle` - styling options for zero line, for more details please refer to the source code of the `ZeroLineStyle`.
* `lineStyle` - styling options for chart line, for more details please refer to the source code of the `LineChartLineStyle`.
* `limitStyle` - styling options for limit, for more details please refer to the source code of the `LineChartLimitStyle`.
* `dropLineStyle` - styling options for drop line, for more details please refer to the source code of the `DropLineStyle`.
* `pointStyle` - styling options for point, for more details please refer to the source code of the `LineChartPointStyle`.
* `tooltipStyle` - styling options for tooltip, for more details please refer to the source code of the `TooltipStyle`.
