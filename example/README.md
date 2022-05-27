# MDCharts Example

Demonstrates how to use the mdcharts package.

## `LineChart` Usage

### Periodical monthly unidirectional ascending `LineChart` with customizable text

```dart
LineChart(
  settings: const LineChartSettings.gridless(),
  data: LineChartData(
    gridType: LineChartGridType.monthly,
    dataType: LineChartDataType.unidirectional,
    limit: 80,
    limitText: '80000 ₴',
    titleBuilder: (key, value) => DateFormat.MMMMd().format(key),
    subtitleBuilder: (key, value) => '${(value * 1000).toInt()} ₴',
    xAxisLabelBuilder: (value) => DateFormat.MMMd().format(value),
    data: {
      DateTime(2022, 03, 1): 10,
      DateTime(2022, 03, 2): 15,
      DateTime(2022, 03, 3): 18,
      DateTime(2022, 03, 5): 21,
      DateTime(2022, 03, 7): 28,
      DateTime(2022, 03, 11): 33,
      DateTime(2022, 03, 16): 38,
      DateTime(2022, 03, 20): 83,
    },
  ),
)
```

### Periodical monthly unidirectional descending `LineChart`

```dart
LineChart(
  settings: const LineChartSettings.gridless(),
  data: LineChartData(
    gridType: LineChartGridType.monthly,
    dataType: LineChartDataType.unidirectional,
    data: {
      DateTime(2022, 03, 2): 83,
      DateTime(2022, 03, 3): 76,
      DateTime(2022, 03, 6): 65,
      DateTime(2022, 03, 9): 29,
      DateTime(2022, 03, 11): 15,
      DateTime(2022, 03, 20): 10,
    },
  ),
)
```

### Periodical monthly bidirectional `LineChart` with custom filling, tooltip and visible grid

```dart
LineChart(
  data: LineChartData(
    gridType: LineChartGridType.monthly,
    dataType: LineChartDataType.bidirectional,
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

## Getting Started

For help getting started with Flutter, view
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
