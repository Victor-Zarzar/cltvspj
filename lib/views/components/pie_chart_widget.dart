import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PieChartWidget extends StatelessWidget {
  final Map<String, double> dataMap;
  final List<Color> colorList;
  final double size;

  const PieChartWidget({
    super.key,
    required this.dataMap,
    required this.colorList,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    if (dataMap.isEmpty) {
      return Center(
        child: Text("no_data_display".tr(), style: context.bodySmallDarkBold),
      );
    }

    final entries = dataMap.entries.toList();
    final total = entries.fold<double>(0, (sum, e) => sum + e.value.abs());

    final safeTotal = total == 0 ? 1.0 : total;

    final sections = List.generate(entries.length, (index) {
      final entry = entries[index];
      final color = colorList[index % colorList.length];
      final value = entry.value.abs();
      final percentage = (value / safeTotal) * 100;

      const minLabelPercent = 7.0;
      final showLabel = percentage >= minLabelPercent;

      final baseFontSize = size / 9;
      final fontSize = baseFontSize.clamp(8.0, 16.0);

      return PieChartSectionData(
        color: color,
        value: value,
        title: showLabel ? value.toStringAsFixed(0) : '',
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: TextColor.primaryColor,
        ),
        radius: size / 2.5,
      );
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: size,
          width: size,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 1,
              centerSpaceRadius: size / 4.8,
              startDegreeOffset: -90,
            ),
            swapAnimationDuration: const Duration(milliseconds: 600),
            swapAnimationCurve: Curves.easeOutCubic,
          ),
        ),
        const SizedBox(height: 40),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: List.generate(entries.length, (index) {
            final entry = entries[index];
            final color = colorList[index % colorList.length];
            final value = entry.value.abs();
            final percentage = (value / safeTotal) * 100;

            final legendText =
                '${entry.key} (${percentage.toStringAsFixed(1)}%)';

            return Indicator(color: color, text: legendText);
          }),
        ),
      ],
    );
  }
}

class Indicator extends StatelessWidget {
  final Color color;
  final String text;

  const Indicator({super.key, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                text,
                style: context.bodySmall,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
      },
    );
  }
}
