import 'package:cltvspj/controller/controllers/pj_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
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
    return Consumer2<UiProvider, PjController>(
      builder: (context, notifier, controller, _) {
        final chartData = PjChartDataHelper.buildResultChartData(
          tax: controller.tax,
          inss: controller.inss,
          benefits: controller.benefits,
          accountantFee: controller.accountantFee,
          netSalary: controller.netSalary,
        );

        final colorList = [
          ChartColor.primaryColor,
          ChartColor.secondaryColor,
          ChartColor.thirdColor,
          ChartColor.fourthColor,
          ChartColor.sixthColor,
        ];

        final mediaQuery = MediaQuery.of(context);
        final width = mediaQuery.size.width;
        final height = mediaQuery.size.height;
        final bool isTablet = width >= 850 && width < 1100;
        final bool isDesktop = width >= 1100;
        final double chartSize = (isTablet || isDesktop) ? 220 : 170;
        final double maxDialogContentHeight = height * 0.8;

        return AlertDialog(
          backgroundColor: notifier.isDark
              ? AlertDialogColor.thirdColor
              : AlertDialogColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 24,
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          title: Text('result'.tr(), style: context.h1Dialog),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: maxDialogContentHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PieChartWidget(
                    dataMap: chartData,
                    colorList: colorList,
                    size: chartSize,
                  ),
                  const SizedBox(height: 16),
                  _buildSalaryLine(
                    context,
                    label: 'taxes'.tr(),
                    value: controller.tax,
                  ),
                  const SizedBox(height: 4),
                  _buildSalaryLine(
                    context,
                    label: 'benefits_pj'.tr(),
                    value: controller.benefits,
                  ),
                  const SizedBox(height: 4),
                  _buildSalaryLine(
                    context,
                    label: 'inss'.tr(),
                    value: controller.inss,
                  ),
                  const SizedBox(height: 4),
                  _buildSalaryLine(
                    context,
                    label: 'accountant_fee'.tr(),
                    value: controller.accountantFee,
                  ),
                  Divider(
                    color: notifier.isDark
                        ? DividerColor.primaryColor.withValues(alpha: 0.15)
                        : DividerColor.secondaryColor.withValues(alpha: 0.1),
                    thickness: 1,
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '${'total_liquid'.tr()}: ${currencyFormat.format(controller.netSalary)}',
                    style: context.bodySmallDarkBold,
                  ),
                ],
              ),
            ),
          ),
          actionsAlignment: .end,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: notifier.isDark
                    ? TextButtonColor.fourthColor.withValues(alpha: 0.1)
                    : TextButtonColor.fiveColor.withValues(alpha: 0.05),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
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
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: context.bodySmallDark,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          Text(currencyFormat.format(value), style: context.bodySmallDarkBold),
        ],
      ),
    );
  }
}
