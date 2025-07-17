import 'package:cltvspj/controller/calculator_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/utils/chart_data_helper.dart';
import 'package:cltvspj/views/components/pie_chart_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultDialog extends StatelessWidget {
  final NumberFormat currencyFormat;

  const ResultDialog({super.key, required this.currencyFormat});

  static void show(BuildContext context, NumberFormat currencyFormat) {
    showDialog(
      context: context,
      builder: (_) => ResultDialog(currencyFormat: currencyFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<CalculatorController>();
    final totalClt = controller.totalClt;
    final totalPj = controller.totalPj;
    final difference = (totalClt - totalPj).abs();

    final chartData = ChartDataHelper.buildResultChartData(
      cltNet: totalClt,
      pjNet: totalPj,
    );

    final colorList = [ChartColor.thirdColor, ChartColor.fourthColor];

    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return AlertDialog(
          title: Text('result'.tr()),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PieChartWidget(
                  dataMap: chartData,
                  colorList: colorList,
                  size: 180,
                ),
                const SizedBox(height: 16),
                Text(
                  'clt_net'.tr(
                    namedArgs: {'amount': currencyFormat.format(totalClt)},
                  ),
                  style: context.bodySmallDark,
                ),
                Text(
                  'pj_net'.tr(
                    namedArgs: {'amount': currencyFormat.format(totalPj)},
                  ),
                  style: context.bodySmallDark,
                ),
                const SizedBox(height: 8),
                Text(
                  'difference'.tr(
                    namedArgs: {'amount': currencyFormat.format(difference)},
                  ),
                  style: context.bodySmallDarkBold,
                ),
                const SizedBox(height: 8),
                Text(controller.bestOption, style: context.bodySmallDarkBold),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('close'.tr(), style: context.bodySmallDarkBold),
            ),
          ],
        );
      },
    );
  }
}
