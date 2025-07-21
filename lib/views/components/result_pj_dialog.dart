import 'package:cltvspj/controller/pj_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/utils/chart_pj_data_helper.dart';
import 'package:cltvspj/views/components/pie_chart_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResultPjtDialog extends StatelessWidget {
  const ResultPjtDialog({super.key, required this.currencyFormat});

  final NumberFormat currencyFormat;

  static void show(BuildContext context, NumberFormat currencyFormat) {
    showDialog(
      context: context,
      builder: (_) => ResultPjtDialog(currencyFormat: currencyFormat),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PjController>(
      builder: (context, ctrl, _) {
        final chartData = PjChartDataHelper.buildResultChartData(
          tax: ctrl.tax,
          inss: ctrl.inss,
          accountantFee: ctrl.accountantFee,
          netSalary: ctrl.netSalary,
        );

        final colorList = [
          ChartColor.primaryColor,
          ChartColor.secondaryColor,
          ChartColor.thirdColor,
          ChartColor.fourthColor,
        ];

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
                const SizedBox(height: 24),
                _buildSalaryLine(context, label: 'tax'.tr(), value: ctrl.tax),
                _buildSalaryLine(context, label: 'inss'.tr(), value: ctrl.inss),
                _buildSalaryLine(
                  context,
                  label: 'accountant_fee'.tr(),
                  value: ctrl.accountantFee,
                ),
                const SizedBox(height: 24),
                _buildSalaryLine(
                  context,
                  label: 'net_salary'.tr(),
                  value: ctrl.netSalary,
                ),
                const SizedBox(height: 8),
                Text(
                  '${'net_salary'.tr()}: ${currencyFormat.format(ctrl.netSalary)}',
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
