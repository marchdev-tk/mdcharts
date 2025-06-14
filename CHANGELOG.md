# Changelog

## 6.5.0 - 10.06.2025

* Changes of the `LineChart`:
  * Added `LineType` to `LineChartSettings` with `LineType.plain` (old) and `LineType.curved` (new) options.

## 6.4.2 - 09.06.2025

* Changes of the `LineChart`:
  * Added `LineChartData.onSelectionChanged` callback.

## 6.4.1 - 09.06.2025

* Updated readme files to reflect recent changes.

## 6.4.0 - 09.06.2025

* **BREAKING CHANGES** of the `LineChart`:
  * Added `PointPaintingType` to `LineChartSettings` instead of `LineChartSettings.showPoint`.

* **BREAKING CHANGES** of the `GridAxis` based charts:
  * Divided `GridAxisSettings.showDropLine` into `GridAxisSettings.showAxisXDropLine` and `GridAxisSettings.showAxisYDropLine`.

* Other changes of the `GridAxis` based charts:
  * Added `DropLineStyle.xAxisGradient` and `DropLineStyle.yAxisGradient` to drop line.
  * Fixed drop line painter.

## 6.3.6 - 05.02.2025

* Fixed the double inaccuracy issue.
* Fixed issue of `YAxisBaseline.axis` type charts with relativity of divisionSize, minValue and maxValue (that caused charts upper boundary to obscure peak values).

## 6.3.5 - 03.02.2025

* Fixed rounding utils.

## 6.3.4 - 03.02.2025

* Fixed dependencies to support `flutter 3.24.0`.

## 6.3.3 - 03.02.2025

* Fixed changelog 😊.

## 6.3.2 - 03.02.2025

* Fixed `BarChart` static analysis issues.

## 6.3.1 - 03.02.2025

* **BREAKING CHANGES** of the `GridAxis` based charts:
  * Key type changed from `num` to `String` for `roundingMap`.

* Other changes of the `GridAxis` based charts:
  * Fixed decimal utils.
  * Reimplemented min and max rounding behaviour for `YAxisBaseline.axis` type.
  * Added `ChartData.maxDataValue`.
* Fixed Material3 theme issue.

## 6.3.0 - 29.08.2024

**BREAKING CHANGES**:
  * Updated dependencies.
  * Updated sdk constraints to `dart 3.5` / `flutter 3.24.0`.

## 6.2.1 - 19.08.2024

* Changes of the `GridAxis` based charts (`LineChart`/`CandlestickChart`):
  * Added extra condition (if data is default alongside with empty data) for painting `GridAxisSettings.defaultDivisionInterval`.

## 6.2.0 - 19.08.2024

* Changes of the `GridAxis` based charts (`LineChart`/`CandlestickChart`):
  * Added `defaultDivisionInterval` to `GridAxisSettings`.
  * Fixed `GirdAxisUtils.adjustMap`.

## 6.1.4 - 16.08.2024

* Changes of the `GridAxis` based charts (`LineChart`/`CandlestickChart`):
  * Fixed `GirdAxisUtils.adjustMap`.

## 6.1.3 - 02.08.2024

* Changes of the `CandlestickChart`:
* Changes of the `LineChart`:
  * Fixed an issue of `YAxisLayout.displace` initial painting without a displacement (issue [#13](https://github.com/marchdev-tk/mdcharts/issues/13)).

## 6.1.2 - 01.08.2024

* Changes of the `LineChart`:
  * Added burndown data generator to line chart example.
* Changes of the `GridAxis` based charts (`LineChart`/`CandlestickChart`):
  * Fixed painting issue of gridless settings constructor (issue [#10](https://github.com/marchdev-tk/mdcharts/issues/10)).
  * Fixed incorrect painting If all data is zero (issue [#11](https://github.com/marchdev-tk/mdcharts/issues/11)).
  * Fixed an issue of map adjuster (issue [#12](https://github.com/marchdev-tk/mdcharts/issues/12)).

## 6.1.1 - 31.07.2024

* Downgraded `decimal` dependency version to `^2.3.3`.

## 6.1.0 - 31.07.2024

* Changes of the `CandlestickChart`:
  * Added doji painting.
  * Tooltip reacting on both X and Y axis instead of only on X axis.
* Changes of the `LineChart`:
  * Added ability to set starting point of the `LineChart`.
  * Removed explicit configuration of `LineChartDataType`.
  * Altitude line is painting to the X axis instead of zero line.
  * Line filling path is closed thru either the bottom part of the grid or the top part instead of the starting point.
    (Generally it means that line filling is beautified)
  * Adjusted `LineChart` example.
* Changes of the `GridAxis` based charts (`LineChart`/`CandlestickChart`):
  * Implemented data below 1 calculations for rounding util.
  * Added `yAxisBaseline` to settings.
  * X axis fixed at the bottom and no more attached to zero line.
  * Drop line is painting to the X axis instead of zero line.
  * Added zero line as a painting option.
  * Added ability to use several lines in tooltips.

## 6.0.3 - 22.07.2024

* Changes of the `CandlestickChart`:
* Changes of the `LineChart`:
  * Fixed gridaxis redundant paddings.

## 6.0.2 - 21.05.2024

* Changes of the `CandlestickChart`:
* Changes of the `LineChart`:
  * Fixed tooltip title/subtitle builders.

## 6.0.1 - 21.05.2024

* Documentation cleanup.

## 6.0.0 - 21.05.2024

* Added `CandlestickChart`.
* Changes of the `LineChart`:
  * Excluded from `LineChartPointStyle` into separate styles `DropLineStyle` and `TooltipStyle`. 
  * Extended example.
  * Huge refactoring with BREAKING CHANGES.

## 5.0.7 - 13.02.2024

* Changes of the `LineChart`:
  * Temp fix of out of range exception.

## 5.0.6 - 13.02.2024

* Changes of the `LineChart`:
  * Temp fix of out of range exception.

## 5.0.5 - 17.01.2024

* Changes of the `LineChart`:
  * Added `showPoint`, `showTooltip` and `selectionEnabled` customisation options to `LineChartSettings`.
  * Fixed typo in `LineChartPointStyle` (`tooltopBottomMargin` -> `tooltipBottomMargin`).

## 5.0.4 - 08.01.2023

* Changes of the `DonutChart`:
  * Fixed selected index reassignment on widget updates.
* Changes of the `GaugeChart`:
  * Fixed selected index reassignment on widget updates.

## 5.0.3 - 21.12.2023

* Changes of the `DonutChart`:
  * Fixed selected section painting issue.
* Changes of the `GaugeChart`:
  * Fixed selected section painting issue.

## 5.0.2 - 21.12.2023

* Changes of the `DonutChart`:
  * Fixed selected section painting issue.
  * Renamed `showInitialAnimation` to `runInitialAnimation` and moved it to `DonutChartSettings`.
* Changes of the `GaugeChart`:
  * Fixed selected section painting issue.
  * Added `runInitialAnimation` to `GaugeChartSettings`.

## 5.0.1 - 20.12.2023

* Changes of the `DonutChart`:
  * Adjusted arc caching mechanism.
* Changes of the `GaugeChart`:
  * Adjusted arc caching mechanism.
  * Adjusted animation mechanism.

## 5.0.0 - 20.12.2023

* Added `DonutChart`.

## 4.5.3 - 12.12.2023

* Changes of the `LineChart`:
  * Adjusted x axis labels painting positions.

## 4.5.2 - 08.12.2023

* Changes of the `LineChart`:
  * Adjusted x axis labels painting positions.

## 4.5.1 - 07.12.2023

* Changes of the `LineChart`:
  * Fixed first and last label positions.
  * Fixed `LineChartGridType` related issue with labels.

## 4.5.0 - 06.12.2023

* Changes of the `BarChart`:
  * Replaced axis painting from main painter to grid painter.
* Changes of the `LineChart`:
  * Reimplemented label painter and improved it's functionality.

## 4.4.3 - 01.12.2023

* Changes of the `BarChart`:
  * Fixed ValueStream issue.

## 4.4.2 - 27.11.2023

* Changes of the `BarChart`:
  * Added new setting `BarChartSettings.showAxisXSelectedLabelIfConcealed`.
  * Fixed labels positioning for `BarAlignment.start` and `BarAlignment.center`.

## 4.4.1 - 27.11.2023

* Changes of the `BarChart`:
  * Limited label selection only for `InteractionType.selection`.

## 4.4.0 - 27.11.2023

* Changes of the `BarChart`:
  * Reimplemented `BarChart` X axis labels, from Widgets to CustomPainter. 
  * Reorganized padding and clipping mechanics.
  * Fixed `YAxisLayout.displace` related issue for `BarFit.contain` and no bar compression (incorrect item hit testing).
  * Fixed `BarFit.none` issue with state updating.

## 4.3.0 - 21.11.2023

* Changes of the `BarChart`:
  * Fixed user input point interpolation to chart coordinate system.

## 4.2.1 - 20.11.2023

* Changes of the `BarChart`:
  * Added `titleBuilder` and `subtitleBuilder` of `BarChartData` to hashCode and equality operator.

## 4.2.0 - 17.11.2023

* Changes of the `BarChart`:
  * Added `BarChartTooltipStyle` to `BarChartStyle`.
  * Added tooltip builders to `BarChartData`.
  * Added `Tooltip Style` section to example app.
  * Implemented tooltip painter. 

## 4.1.8 - 16.11.2023

* Changes of the `BarChart`:
  * Implemented `InteractionType.overview`, now in this mode the chart will be able to track the drag gesture to temporarily change the currently selected bar group.
  * Added `BarChartSettings.xAxisLabelQuantity` that is working in a conjunction with `InteractionType.overview` mode to limit the quantity of X axis labels.
* Changes of the `LineChart`:
  * Fixed doc comment of `LineChartSettings.xAxisLabelQuantity`.

## 4.1.7 - 15.11.2023

* Changes of the `BarChart`:
  * Fixed typo of `InteractionType`.

## 4.1.6 - 14.11.2023

* Changes of the `BarChart`:
  * Changed from `BarChartSettings.showSelection` to `InteractionType` enum.
* Added `RepaintBoundary` to all charts.

## 4.1.5 - 10.04.2023

* Changes of the `BarChart`:
  * Fixed issue with initial animation.

## 4.1.4 - 09.04.2023

* Changes of the `BarChart`:
  * Fixed check for data equality on didUpdateWidget.

## 4.1.3 - 09.04.2023

* Changes of the `BarChart`:
  * Added check for data equality on didUpdateWidget.

## 4.1.2 - 09.04.2023

* Changes of the `BarChart`:
  * Removed redundant animation triggered by didUpdateWidget instantly after initState.

## 4.1.1 - 03.04.2023

* Changes of the `BarChart`:
  * Improved stability of painter `selectedPeriod` usages.
  * Moved creation of charts BehaviorSubjects into state itself instead of initState method.
  * Improved stability of subscriptions of chart widget.

## 4.1.0 - 29.03.2023

* Changes of the `BarChart`:
  * Fixed `YAxisLayout.displace` issue that caused wrong tap zones when `BarFit.contain` was set.

## 4.0.9 - 29.03.2023

* Changes of the `BarChart`:
  * Fixed `onSelectedPeriodChanged` extra subscriptions and false triggering

## 4.0.8 - 29.03.2023

* Changes of the `BarChart`:
  * Fixed selected period calculation.

## 4.0.7 - 28.03.2023

* Changes of the `BarChart`:
  * Reimplemented animations to firstly animate backward with old data/style/settings and then animate forward with new data/style/settings.

## 4.0.6 - 03.03.2023

* Changes of the `GaugeChart`:
  * Fixed redundant rebuilds.

## 4.0.5 - 02.03.2023

* Changes of the `LineChart`:
  * Removed builder functions from LineChartData `hashCode` and `equals`.
  * Changed `hashMap` usage to default `hashCode` due to unexpected behaviour.

## 4.0.4 - 07.11.2022

* Changes of the `LineChart`:
  * Fixed temp solution of summer/winter time shifts.

## 4.0.3 - 03.11.2022

* Changes of the `LineChart`:
  * Added temp solution to fix summer/winter time shifts.

## 4.0.2 - 03.11.2022

* Changes of the `LineChart`:
  * Fixed typedData dates generator again.

## 4.0.1 - 28.10.2022

* Changes of the `LineChart`:
  * Fixed typedData dates generator.

## 4.0.0 - 18.10.2022

* Changes of the `LineChart`:
  * Fixed documentation.

* Changes of the `GaugeChart`:
  * Redesigned section tap handling (moved it from painter to widget).
  * Fixed `GaugeChartData` hash code generation.
  * Fixed limitation that prevented from drawing more then one chart on the screen.

## 4.0.0-dev.14 - 14.10.2022

* Changes of the `LineChart`:
  * Fixed initial dot position.

## 4.0.0-dev.13 - 28.09.2022

* Changes of the `GaugeChart`:
  * Fixed normalized lists mismatch in case of initial zero only data.

## 4.0.0-dev.12 - 16.09.2022

* Changes of the `LineChart`:
  * Added line and point animation.

## 4.0.0-dev.11 - 08.09.2022

* Changes of the `BarChart`:
  * Redesigned border painting on the bars that are smaller then border stroke plus top bar radius.

## 4.0.0-dev.10 - 07.09.2022

* Fixes of the `BarChart`:
  * Fixed padding issue of `BarChart` with `BarFit.contain` fit type.
  * Fixed tap handling of `BarChart` with `BarFit.contain` fit type.

* Changes of the `BarChart`:
  * Redesigned zero bars to use border color as a main color if any provided, otherwise will fallback to normal color selection type.

## 4.0.0-dev.9 - 07.09.2022

* Changes of the `BarChart`:
  * Added separate colors for selected bars.
  * Added bar border customizations.
  * Added shadow customizations.
  * Added Y axis label layout customizations.
  * Added bar fitting customizations.

## 4.0.0-dev.8 - 18.08.2022

* Reverted previous change.
* Mark custom paint of `GaugeChart` as complex.

## 4.0.0-dev.7 - 18.08.2022

* Increased blur radius from 1px to 2px.

## 4.0.0-dev.6 - 18.08.2022

* Added blur for the edges of the `GaugeChart` to remove "sharpened" edges (possibly it is caused by flutter itself).

## 4.0.0-dev.5 - 17.08.2022

* Added explicitly anti-aliasing to all `Paint`'s.
* Set `filterQuality` to `FilterQuality.medium` for all `Paint`'s.

## 4.0.0-dev.4 - 02.08.2022

* Changed `GaugeChart.onSelectionChanged` delegate type from `ValueChanged<int>` to `IndexedPredicate` which now allows to control whether animation is needed or not by passing `true/false` as a return value.

## 4.0.0-dev.3 - 02.08.2022

* Adjusted `GaugeChartBackgroundStyle.borderFilled` check before painting border.
* Removed ignoring of the taps over already selected section as it caused more issues than value.

## 4.0.0-dev.2 - 01.08.2022

* Fixed `GaugeChartBackgroundStyle.borderColor` default value.
* Redo radius calculation, changed constraints from `Size.shortestSize` to `Size.width`.

## 4.0.0-dev.1 - 01.08.2022

* Added `GaugeChart`.
* Limitations:
  * Large borders are drawing outside of the path on the bottom side;
  * Only one chart could be on the screen;
  * No documentation for gauge chart.

## 3.1.1 - 21.07.2022

* Adjusted drawing of limited X axis labels.
* Adjusted example app.

## 3.1.0 - 18.07.2022

* Added `xAxisLabelQuantity` to `LineChartSettings` which defines the quantity of the X axis labels to draw.

## 3.0.0 - 30.06.2022

Full list of chages:

### 3.0.0-dev.6 - 30.06.2022

* Added caching of the typedData getter, it will significantly improve rendering performance of the `LineChart`.

### 3.0.0-dev.5 - 30.06.2022

* Added caching of the division size calculation method, it will significantly improve rendering performance of the `LineChart`.

### 3.0.0-dev.4 - 29.06.2022

* Added negative values support to `LineChart`.

### 3.0.0-dev.3 - 28.06.2022

* Fixed grid redraw issue caused by usage of old data due to animation implementation.

### 3.0.0-dev.2 - 28.06.2022

* Fixed taps on `BarChart`s bars.

### 3.0.0-dev.1 - 27.06.2022

* Added animation for the `BarChart`.
* Added alignment of the bars for the `BarChart`.
* **BREAKING CHANGE:**
  * chart data are now drawing from the first to the last item (in previous versions they were drawn reversed), and this change has led to changes in `BarChartData.selectedPeriod` getter (previously used to get first item as fallback, but now - last item).

## 2.1.1 - 21.06.2022

* Added ability to tap between chart and x axis label.

## 2.1.0 - 17.06.2022

* Added handling of taps over the bar chart.

## 2.0.3 - 03.06.2022

* Fixed `selectedPeriod` functionality.

## 2.0.2 - 01.06.2022

* Fixed `onSelectedPeriodChanged` raising from selection changed.
* Fixed grid and axis positioning if there's no data initially provided.

## 2.0.1 - 01.06.2022

* Added TextStyle to the RichLabelBuilder delegate.
* Fixed zero length data chart drawing.
* Fixed extra scrolling if padding was provided.
* Fixed label positioning if there's too few data.

## 2.0.0 - 31.05.2022

* Added `BarChart`.

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
