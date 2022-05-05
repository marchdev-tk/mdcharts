# Changelog

## 1.4.1 - 05.05.2022

* Fixed `LimitLabelSnapPosition.chartBoundary` bias calculations.

## 1.4.0 - 04.05.2022

* Removed bool parameters `showFirstAxisYDivision` and `showLastAxisXDivision` and added enum `AxisDivisionEdges` that provides more complex customization of axis divisions at the edges of the grid.
* Added snap position of limit label.
* Added labels to the Y axis of the chart, that caused redesigning of `maxValue` calculation mechanic.

## 1.3.2 - 01.04.2022

* Fixed chart drawing with only 1 data entry.

## 1.3.1 - 30.03.2022

* Added detection of `horizontal drag start`.

## 1.3.0 - 30.03.2022

* Redesigned drawing of the first point.
* Fixed timezone issue.
* Fixed styles for point drop line stroke.

## 1.2.3 - 26.03.2022

* Fixed value normalization if all provided data is 0.

## 1.2.2 - 26.03.2022

* Fixed StackOverflowException for descending unidirectional chart.
* Fixed `xAxisDates` getter for unidirectional chart with empty data.

## 1.2.1 - 26.03.2022

* Fixed `typedData` getter when data is empty.

## 1.2.0 - 26.03.2022

* Allowed chart creation with less then 2 points.
* Added option to set padded value to max value.

## 1.1.0 - 25.03.2022

* Fixed color/gradient fill.
* Added to `LineChartGridStyle` stroke and color for X and Y axis as a separate values.
* Added option to show first Y axis grid line.
* Added option to show last X axis grid line.
* Renamed blurRadius to shadowBlurRadius in `LineChartLineStyle`.

## 1.0.1 - 25.03.2022

* Added changelog.

## 1.0.0 - 25.03.2022

* Added `LineChart`.
