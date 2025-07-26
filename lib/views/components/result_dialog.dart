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
  const ResultDialog({super.key, required this.currencyFormat});

  final NumberFormat currencyFormat;

  static void show(BuildContext context, NumberFormat currencyFormat) {
    showDialog(
      context: context,
      builder: (_) => ResultDialog(currencyFormat: currencyFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UiProvider, CalculatorController>(
      builder: (context, notifier, controller, child) {
        final chartData = ChartDataHelper.buildResultChartData(
          cltNet: controller.totalClt,
          pjNet: controller.totalPj,
          difference: controller.difference,
          benefits: controller.benefits,
          inss: controller.inss,
          accountantFee: controller.accountantFee,
        );

        final colorList = [
          ChartColor.thirdColor,
          ChartColor.secondaryColor,
          ChartColor.primaryColor,
          ChartColor.fourthColor,
          ChartColor.fifthColor,
        ];

        return AlertDialog(
          backgroundColor: notifier.isDark
              ? AlertDialogColor.thirdColor
              : AlertDialogColor.primaryColor,
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
                const SizedBox(height: 12),
                _buildSalaryLine(
                  context,
                  label: 'clt_net'.tr(),
                  value: controller.totalClt,
                ),
                const SizedBox(height: 4),
                _buildSalaryLine(
                  context,
                  label: 'pj_net'.tr(),
                  value: controller.totalPj,
                ),
                const SizedBox(height: 4),
                _buildSalaryLine(
                  context,
                  label: 'accountant_fee'.tr(),
                  value: controller.accountantFee,
                ),
                const SizedBox(height: 4),
                _buildSalaryLine(
                  context,
                  label: 'benefits'.tr(),
                  value: controller.benefits,
                ),
                const SizedBox(height: 4),
                _buildSalaryLine(
                  context,
                  label: 'inss_pj_description'.tr(),
                  value: controller.inss,
                ),
                const SizedBox(height: 4),
                _buildSalaryLine(
                  context,
                  label: 'difference'.tr(),
                  value: controller.difference,
                ),
                const SizedBox(height: 14),
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
