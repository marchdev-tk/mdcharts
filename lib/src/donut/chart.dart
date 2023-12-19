import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

import 'cache.dart';
import 'data.dart';
import 'painter.dart';
import 'settings.dart';
import 'style.dart';

@immutable
class DonutChart extends StatefulWidget {
  const DonutChart({
    super.key,
    required this.data,
    this.settings = const DonutChartSettings(),
    this.style = const DonutChartStyle(),
    this.showInitialAnimation = false,
  });

  final DonutChartData data;
  final DonutChartSettings settings;
  final DonutChartStyle style;

  final bool showInitialAnimation;

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart>
    with SingleTickerProviderStateMixin {
  final _selectedIndex = BehaviorSubject<int>();
  final _oldSelectedIndex = BehaviorSubject<int>.seeded(0);

  late AnimationController _valueController;
  late Animation<double> _valueAnimation;

  late DonutChartData data;
  DonutChartData? oldData;
  int? dataHashCode;

  void startAnimation() {
    if (widget.data == oldData) {
      return;
    }

    _valueController.forward(from: 0);
  }

  void _handleTapUp(Offset position) {
    final pathHolders = cache.getPathHolders(widget.data.hashCode) ?? [];

    if (pathHolders.isEmpty) {
      return;
    }

    for (var i = 0; i < widget.data.data.length; i++) {
      final contains = pathHolders[i].contains(position);

      if (contains && _selectedIndex.value != i) {
        _oldSelectedIndex.add(_selectedIndex.value);
        _selectedIndex.add(i);
        widget.data.onSelectionChanged?.call(i);
        startAnimation();
      }
    }
  }

  @override
  void initState() {
    data = widget.data;
    dataHashCode = data.hashCode;
    cache.add(dataHashCode!, oldData.hashCode);

    _selectedIndex.add(data.initialSelectedIndex ?? 0);

    _valueController = AnimationController(
      value: widget.showInitialAnimation ? 0 : 1,
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _valueAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _valueController,
      curve: Curves.easeInOut,
    ));
    if (widget.showInitialAnimation) {
      startAnimation();
    }

    super.initState();
  }

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    data = widget.data;
    dataHashCode = data.hashCode;
    if (data != oldWidget.data) {
      oldData = oldWidget.data;
    }
    final oldDataHashCode = oldData?.hashCode;

    if (oldData.hashCode != oldDataHashCode) {
      cache.add(oldData.hashCode, oldDataHashCode);
      cache.add(dataHashCode!, oldData.hashCode);
    } else {
      cache.add(dataHashCode!, oldData.hashCode);
    }

    if (data != oldWidget.data) {
      startAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: GestureDetector(
        onTapUp: widget.settings.selectionEnabled
            ? (details) => _handleTapUp(details.localPosition)
            : null,
        child: AnimatedBuilder(
          animation: _valueAnimation,
          builder: (context, child) {
            return CustomPaint(
              isComplex: true,
              painter: DonutPainter(
                widget.data,
                widget.settings,
                widget.style,
                oldData,
                dataHashCode!,
                _selectedIndex,
                _oldSelectedIndex,
                _valueAnimation.value,
              ),
              size: Size.infinite,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }
}
