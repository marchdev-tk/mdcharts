# MDCharts Example

Demonstrates how to use the mdcharts package.

## `LineChart` Usage

For more info about how to use `LineChart` please refer to the example app.

### Periodical monthly `LineChart` with custom filling, tooltip and visible grid

```dart
LineChart(
  data: LineChartData(
    gridType: LineChartGridType.monthly,
    limit: 90,
    data: {
      DateTime(2022, 02, 2): 10,
      DateTime(2022, 02, 4): 15,
      DateTime(2022, 02, 5): 19,
      DateTime(2022, 02, 6): 21,
      DateTime(2022, 02, 7): 17,
      DateTime(2022, 02, 8): 3,
      DateTime(2022, 02, 23): 73,
      DateTime(2022, 02, 24): 82,
      DateTime(2022, 02, 25): 83,
      DateTime(2022, 02, 26): 81,
      DateTime(2022, 02, 27): 77,
      DateTime(2022, 02, 28): 70,
    },
  ),
  style: const LineChartStyle(
    lineStyle: LineChartLineStyle(
      fillColor: Colors.white24,
      fillGradient: null,
    ),
    pointStyle: LineChartPointStyle(
      tooltipRadius: 20,
      tooltipTriangleWidth: 16,
      tooltipTriangleHeight: 12,
    ),
  ),
)
```

### Undefined `LineChart` with custom limit label

```dart
LineChart(
  settings: const LineChartSettings.gridless(),
  style: LineChartStyle(
    limitStyle: LineChartLimitStyle(
      labelStyle: LineChartLimitStyle.defaultStyle.copyWith(
        fontSize: 20,
      ),
      labelOveruseStyle: LineChartLimitStyle.defaultStyle.copyWith(
        fontSize: 20,
      ),
    ),
  ),
  data: LineChartData(
    gridType: LineChartGridType.undefined,
    limit: 50,
    limitText: 'Custom label text',
    data: {
      DateTime(2022, 03, 2): 10,
      DateTime(2022, 03, 4): 15,
      DateTime(2022, 03, 5): 29,
      DateTime(2022, 03, 20): 83,
    },
  ),
)
```

## `BarChart` Usage

```dart
BarChart(
  settings: const BarChartSettings(),
  style: const BarChartStyle(),
  data: BarChartData(
    data: {
      DateTime(2022): [12345, 23456],
      DateTime(2021): [1234, 1000],
      DateTime(2020): [500, 500],
      DateTime(2019): [0, 0],
      DateTime(2018): [200, 0],
      DateTime(2017): [0, 200],
      DateTime(2016): [0, 0],
      DateTime(2015): [0, 0],
      DateTime(2014): [20, 0],
      DateTime(2013): [0, 20],
      DateTime(2012): [0, 0],
    },
  ),
)
```

For more info about how to use `BarChart` please refer to the example app.

## `GaugeChart` Usage

```dart
GaugeChart(
  settings: const GaugeChartSettings(),
  style: const GaugeChartStyle(),
  data: GaugeChartData(
    data: [12345, 23456, 1000, 500],
    selectedIndex: 1,
    onSelectionChanged: (i) {
      // do something with newly selected section index
      //
      // if it will not be set as selectedIndex, then selection will not be changed

      return true; // if true is returned then animation will be triggered, otherwise - animation will not be triggered
    },
  ),
)
```

For more info about how to use `GaugeChart` please refer to the example app.

## `DonutChart` Usage

```dart
DonutChart(
  settings: const DonutChartSettings(),
  style: const DonutChartStyle(),
  data: DonutChartData(
    data: [12345, 23456, 1000, 500],
    selectedIndex: 1,
    onSelectionChanged: (i) {
      // do something with newly selected section index
      //
      // if it will not be set as selectedIndex, then selection will not be changed
    },
  ),
)
```

For more info about how to use `DonutChart` please refer to the example app.

## `CandlestickChart` Usage

```dart
CandlestickChart(
  settings: const CandlestickChartSettings(),
  style: const CandlestickChartStyle(),
  data: CandlestickChartData(
    data: {
      DateTime(2022, 7):     const CandlestickData(low: 100, high: 250, bid: 150, ask: 200),
      DateTime(2022, 7, 02): const CandlestickData(low: 0  , high: 50 , bid: 50 , ask: 20 ),
      DateTime(2022, 7, 03): const CandlestickData(low: 300, high: 450, bid: 350, ask: 320),
      DateTime(2022, 7, 04): const CandlestickData(low: 200, high: 250, bid: 200, ask: 250),
      DateTime(2022, 7, 05): const CandlestickData(low: 220, high: 250, bid: 230, ask: 230),
      DateTime(2022, 7, 06): const CandlestickData(low: 250, high: 350, bid: 250, ask: 250),
    },
    subtitleBuilder: (key, value) {
      final doubleValue = CandlestickChartData.getSelectedValueFromData(value);
      return doubleValue.toString();
    },
  ),
)
```

For more info about how to use `CandlestickChart` please refer to the example app.

## Getting Started

For help getting started with Flutter, view
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
