# DonutChart

## Data

* ### REQUIRED data

  * `data` - list of `double` values based on which chart will be drawned.

* ### OPTIONAL data

  * `selectedIndex` - index of the selected section, defaults to `null`.
  * `onSelectionChanged` - callbacks that reports that selected section index has changed, defaults to `null`.
  * `onInscribedInCircleSizeChanged` - callbacks that reports that size of the square inscribed in circle has changed, defaults to `null`.

## Settings

* `colorPattern` - pattern which colors will respect while getting from [GaugeChartSectionStyle.colors] field, defaults to `null`.
* `sectionStroke` - stroke (width/size) of the gauge section, defaults to `30`.
* `selectedSectionStroke` - stroke (width/size) of the selected gauge section, defaults to `38`.
* `debugMode` - whether debug mode is enabled or not, defaults to `false`.
* `selectionEnabled` - whether interactive section selection is enabled or not, defaults to `true`.
* `behavior` - how this chart should behave during hit testing, defaults to `HitTestBehavior.deferToChild`.
* `runInitialAnimation` - whether to show initial selection animation or not, defaults to `false`.

## Style

* `backgroundStyle` - styling options for the background, for more details please refer to the source code of the `GaugeChartBackgroundStyle`.
* `sectionStyle` - styling options for the section, for more details please refer to the source code of the `GaugeChartSectionStyle`.
