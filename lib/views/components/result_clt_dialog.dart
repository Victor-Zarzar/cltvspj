import 'package:cltvspj/controller/clt_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/utils/chart_clt_data_helper.dart';
import 'package:cltvspj/views/components/pie_chart_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultCltDialog extends StatelessWidget {
  const ResultCltDialog({super.key, required this.currencyFormat});

  final NumberFormat currencyFormat;

  static void show(BuildContext context, NumberFormat currencyFormat) {
    showDialog(
      context: context,
      builder: (_) => ResultCltDialog(currencyFormat: currencyFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UiProvider, CltController>(
      builder: (context, notifier, controller, _) {
        final chartData = CltChartDataHelper.buildResultChartData(
          netSalary: controller.netSalary,
          inss: controller.inss,
          irrf: controller.irrf,
          benefits: controller.benefits,
        );

        final colorList = [
          ChartColor.primaryColor,
          ChartColor.secondaryColor,
          ChartColor.thirdColor,
          ChartColor.fourthColor,
        ];

        return AlertDialog(
          backgroundColor: notifier.isDark
              ? AlertDialogColor.thirdColor
              : AlertDialogColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('result'.tr(), style: context.h1Dialog),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PieChartWidget(
                  dataMap: chartData,
                  colorList: colorList,
                  size: 180,
                ),
                const SizedBox(height: 24),
                _buildSalaryLine(
                  context,
                  label: 'net_salary'.tr(),
                  value: controller.netSalary,
                ),
                _buildSalaryLine(
                  context,
                  label: 'inss'.tr(),
                  value: controller.inss,
                ),
                _buildSalaryLine(
                  context,
                  label: 'irrf'.tr(),
                  value: controller.irrf,
                ),
                _buildSalaryLine(
                  context,
                  label: 'benefits_clt'.tr(),
                  value: controller.benefits,
                ),
                const SizedBox(height: 8),
                Text(
                  '${'net_salary'.tr()}: ${currencyFormat.format(controller.netSalary)}',
                  style: context.bodySmallDarkBold,
                ),
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

  Widget _buildSalaryLine(
    BuildContext context, {
    required String label,
    required double value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: context.bodySmallDark),
          Text(currencyFormat.format(value), style: context.bodySmallDarkBold),
        ],
      ),
    );
  }
}
