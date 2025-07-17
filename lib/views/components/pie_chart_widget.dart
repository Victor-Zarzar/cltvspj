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

    final sections = dataMap.entries.map((entry) {
      final index = dataMap.keys.toList().indexOf(entry.key);
      final color = colorList[index % colorList.length];

      return PieChartSectionData(
        color: color,
        value: entry.value.abs(),
        title: entry.value.toStringAsFixed(0),
        titleStyle: TextStyle(
          fontSize: size / (entry.value < 100 ? 9 : 11),
          fontWeight: FontWeight.bold,
          color: TextColor.primaryColor,
        ),
        radius: size / 2.3,
      );
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: size / 5,
              startDegreeOffset: -90,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 8,
          children: dataMap.entries.map((entry) {
            final index = dataMap.keys.toList().indexOf(entry.key);
            final color = colorList[index % colorList.length];

            return Indicator(color: color, text: entry.key);
          }).toList(),
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
            Text(text, style: context.bodySmall),
          ],
        );
      },
    );
  }
}
