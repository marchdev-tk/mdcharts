# BarChart

## Data

* ### REQUIRED data

  * `data` - set of data with `DateTime` keys and `List<double>` values based on which chart will be drawned.

* ### Max Value 

  * `predefinedMaxValue` - predefined max value for the chart.
  * `maxValueRoundingMap` - rounding map for the maxValue that is used by beautification function of Y axis labels.

* ### Selection

  * `initialSelectedPeriod` - initial selected period of the bar chart, defaults to `null`.
  * `onSelectedPeriodChanged` - callback that notifies if selected period has changed, defaults to `null`.

* ### Tooltip builders

  * `titleBuilder` - builds title of the tooltip based on `DateTime` key and/or `List<double>` value from provided data.
  * `subtitleBuilder` - builds subtitle of the tooltip based on `DateTime` key and/or `List<double>` value from provided data.

* ### Label builder

  * `xAxisLabelBuilder` - builds X axis label based on `DateTime` value from provided data.
  * `yAxisLabelBuilder` - builds Y axis label based on `double` value from provided data, `maxValue` specifically.

#### Settings

* `yAxisDivisions` - quantity of the Y axis divisions, defaults to `2`.
* `xAxisLabelQuantity` - quantity of the X axis labels to draw, defaults to `null`.
* `axisDivisionEdges` - axis division edges, defaults to `AxisDivisionEdges.none`.
* `showAxisX` - whether to show X axis or not, defaults to `true`.
* `showAxisXLabels` - whether to show labels on the X axis or not, defaults to `true`.
* `showAxisXSelectedLabelIfConcealed` - whether to show selected label if it is concealed by `xAxisLabelQuantity`, defaults to `false`.
* `showAxisYLabels` - whether to show labels on the Y axis or not, defaults to `true`.
* `yAxisLayout` - layout type of the Y axis labels, defaults to `YAxisLayout.overlay`.
* `yAxisLabelSpacing` - spacing between the Y axis labels and chart itself, defaults to `0`.
* `barSpacing` - spacing between bars in one item, defaults to `0`.
* `itemSpacing` - spacing between group of bars, defaults to `12`.
* `interaction` - describes how user will be interacting with chart, defaults to `InteractionType.selection`.
* `duration` - the length of time animation should last, defaults to `400 milliseconds`.
* `alignment` - alignment of the bars within chart, defaults to `BarAlignment.end`.
* `reverse` - whether the scroll view scrolls in the reading direction, defaults to `false`.
* `fit` - insription type of the bars within target box (painting zone), defaults to `BarFit.none`.

#### Style

* `gridStyle` - styling options for the grid, for more details please refer to the source code of the `BarChartGridStyle`.
* `axisStyle` - styling options for the axis, for more details please refer to the source code of the `BarChartAxisStyle`.
* `barStyle` - styling options for the chart line, for more details please refer to the source code of the `BarChartBarStyle`.
* `tooltipStyle` - styling options for the tooltip, for more details please refer to the source code of the `TooltipStyle`.
