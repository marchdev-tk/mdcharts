# MDCharts

![Build](https://github.com/marchdev-tk/mdcharts/workflows/build/badge.svg)
[![Pub](https://img.shields.io/pub/v/mdcharts.svg)](https://pub.dartlang.org/packages/mdcharts)
![GitHub](https://img.shields.io/github/license/marchdev-tk/mdcharts)
![GitHub stars](https://img.shields.io/github/stars/marchdev-tk/mdcharts?style=social)

march.dev charts library. Provides highly customizable and configurable charts.

## Getting Started

### LineChart

#### Data

* ##### REQUIRED data

  * `data` - set of data with `DateTime` keys and `double` values based on which chart will be drawned.

* ##### There are 2 general types of the `LineChart`:

  * **`Periodical` grid type (only `monthly` available for now):**

    Periodical means that if there's not enough data to draw full chart (there's gaps between dates) chart will automatically fulfill lacking data based on `LineChartDataType`.

    * For `LineChartDataType.bidirectional` data type lacking data will be set to `0`.

    * For `LineChartDataType.unidirectional` data type lacking data will calculated from previous values so, that charts will be looking like ascending (e.g. Progress) or descending (e.g. Burndown) chart.

  * **`Undefined` grid type:**

    Undefined means that the chart will be drawned using only provided data.

    Note that `LineChartDataType` is omitted with this type of grid.

* ##### Max Value 

  * `predefinedMaxValue` - predefined max value for the chart.
  * `maxValueRoundingMap` - rounding map for the maxValue that is used by beautification function of Y axis labels.

* ##### Limits

  * `limit` - if provided, will be painted on the chart as a horizontal indication line.
  * `limitText` - custom text to set to the label of the limit line.

  Note that if `limitText` is set without provided `limit`, there will be no limit line.

* ##### Tooltip builders

  * `titleBuilder` - builds title of the tooltip based on `DateTime` key and/or `double` value from provided data.
  * `subtitleBuilder` - builds subtitle of the tooltip based on `DateTime` key and/or `double` value from provided data.

* ##### Label builder

  * `xAxisLabelBuilder` - builds X axis label based on `DateTime` value from provided data.
  * `yAxisLabelBuilder` - builds Y axis label based on `double` value from provided data, `maxValue` specifically.

#### Settings

* `xAxisDivisions` - quantity of the X axis divisions, defaults to `3`.
* `yAxisDivisions` - quantity of the Y axis divisions, defaults to `2`.
* `xAxisLabelQuantity` - quantity of the X axis labels to draw, defaults to `null`.
* `axisDivisionEdges` - axis division edges, defaults to `AxisDivisionEdges.none`.
* `showAxisX` - whether to show X axis or not, defaults to `true`.
* `showAxisXSelectedLabelIfConcealed` - whether to show selected label if it is concealed by `xAxisLabelQuantity`, defaults to `false`.
* `showAxisY` - whether to show Y axis or not, defaults to `true`.
* `lineFilling` - whether to fill chart between the line and the X axis or not, defaults to `true`.
* `lineShadow` - whether to draw shadow beneath the line or not, defaults to `true`.
* `altitudeLine` - whether to draw the altitude line or not, defaults to `true`.
* `limitLabelSnapPosition` - snap position options of limit label, defaults to `LimitLabelSnapPosition.axis`.
* `showAxisXLabels` - whether to show labels on the X axis or not, defaults to `true`.
* `showAxisYLabels` - whether to show labels on the Y axis or not, defaults to `true`.
* `showAxisXLabelSelection` - whether to paint with selected style currently selected X axis label or not, defaults to `false`.

#### Styles

* `gridStyle` - styling options for the grid, for more details please refer to the source code of the `LineChartGridStyle`.
* `axisStyle` - styling options for the axis, for more details please refer to the source code of the `LineChartAxisStyle`.
* `lineStyle` - styling options for the chart line, for more details please refer to the source code of the `LineChartLineStyle`.
* `limitStyle` - styling options for the limit, for more details please refer to the source code of the `LineChartLimitStyle`.
* `pointStyle` - styling options for the point and tooltip above point, for more details please refer to the source code of the `LineChartPointStyle`.

### BarChart

#### Data

* ##### REQUIRED data

  * `data` - set of data with `DateTime` keys and `List<double>` values based on which chart will be drawned.

* ##### Max Value 

  * `predefinedMaxValue` - predefined max value for the chart.
  * `maxValueRoundingMap` - rounding map for the maxValue that is used by beautification function of Y axis labels.

* ##### Selection

  * `initialSelectedPeriod` - initial selected period of the bar chart, defaults to `null`.
  * `onSelectedPeriodChanged` - callback that notifies if selected period has changed, defaults to `null`.

* ##### Tooltip builders

  * `titleBuilder` - builds title of the tooltip based on `DateTime` key and/or `List<double>` value from provided data.
  * `subtitleBuilder` - builds subtitle of the tooltip based on `DateTime` key and/or `List<double>` value from provided data.

* ##### Label builder

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
* `tooltipStyle` - styling options for the tooltip, for more details please refer to the source code of the `BarChartTooltipStyle`.

### GaugeChart

#### Data

* ##### REQUIRED data

  * `data` - list of `double` values based on which chart will be drawned.

* ##### OPTIONAL data

  * `selectedIndex` - index of the selected section, defaults to `null`.
  * `onSelectionChanged` - callbacks that reports that selected section index has changed, defaults to `null`.

#### Settings

* `colorPattern` - pattern which colors will respect while getting from [GaugeChartSectionStyle.colors] field, defaults to `null`.
* `sectionStroke` - stroke (width/size) of the gauge section, defaults to `30`.
* `selectedSectionStroke` - stroke (width/size) of the selected gauge section, defaults to `38`.
* `gaugeAngle` - angle of gauge, defaults to `180`°.
* `debugMode` - whether debug mode is enabled or not, defaults to `false`.
* `selectionEnabled` - whether interactive section selection is enabled or not, defaults to `true`.
* `behavior` - how this chart should behave during hit testing, defaults to `HitTestBehavior.deferToChild`.
* `runInitialAnimation` - whether to show initial selection animation or not, defaults to `false`.

#### Style

* `backgroundStyle` - styling options for the background, for more details please refer to the source code of the `GaugeChartBackgroundStyle`.
* `sectionStyle` - styling options for the section, for more details please refer to the source code of the `GaugeChartSectionStyle`.

### DonutChart

#### Data

* ##### REQUIRED data

  * `data` - list of `double` values based on which chart will be drawned.

* ##### OPTIONAL data

  * `selectedIndex` - index of the selected section, defaults to `null`.
  * `onSelectionChanged` - callbacks that reports that selected section index has changed, defaults to `null`.
  * `onInscribedInCircleSizeChanged` - callbacks that reports that size of the square inscribed in circle has changed, defaults to `null`.

#### Settings

* `colorPattern` - pattern which colors will respect while getting from [GaugeChartSectionStyle.colors] field, defaults to `null`.
* `sectionStroke` - stroke (width/size) of the gauge section, defaults to `30`.
* `selectedSectionStroke` - stroke (width/size) of the selected gauge section, defaults to `38`.
* `debugMode` - whether debug mode is enabled or not, defaults to `false`.
* `selectionEnabled` - whether interactive section selection is enabled or not, defaults to `true`.
* `behavior` - how this chart should behave during hit testing, defaults to `HitTestBehavior.deferToChild`.
* `runInitialAnimation` - whether to show initial selection animation or not, defaults to `false`.

#### Style

* `backgroundStyle` - styling options for the background, for more details please refer to the source code of the `GaugeChartBackgroundStyle`.
* `sectionStyle` - styling options for the section, for more details please refer to the source code of the `GaugeChartSectionStyle`.

## Examples

To see usage example navigate to the [Example](example/README.md) section.

## Feature requests and Bug reports

Feel free to post a feature requests or report a bug [here](https://github.com/marchdev-tk/mdcharts/issues).

## TODO

* Add MdDate to all charts (with unit-tests)
* Add ability to accept custom painters (paint funcs) (requires ENORMOUS amount of time)
