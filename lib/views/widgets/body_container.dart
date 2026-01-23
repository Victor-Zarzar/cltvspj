import 'package:cltvspj/controller/controllers/calculator_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/views/components/custom_button.dart';
import 'package:cltvspj/views/components/input_field.dart';
import 'package:cltvspj/views/components/show_dialog_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyContainer extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController salaryCltController;
  final TextEditingController salaryPjController;
  final TextEditingController benefitsController;
  final TextEditingController taxesPjController;
  final TextEditingController accountantFeeController;
  final TextEditingController inssPjController;
  final VoidCallback onCalculatePressed;
  final double padding;
  final double minHeight;
  final double maxWidth;

  const BodyContainer({
    super.key,
    required this.formKey,
    required this.salaryCltController,
    required this.salaryPjController,
    required this.benefitsController,
    required this.taxesPjController,
    required this.accountantFeeController,
    required this.inssPjController,
    required this.onCalculatePressed,
    required this.padding,
    required this.minHeight,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer2<UiProvider, CalculatorController>(
      builder: (context, notifier, controller, child) {
        return Center(
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SingleChildScrollView(
              padding: EdgeInsets.all(padding),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: maxWidth,
                  minHeight: minHeight,
                ),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: notifier.isDark
                                ? CardColor.primaryColor
                                : CardColor.secondaryColor,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.isDark
                                    ? BoxShadowColor.fifthColor.withValues(
                                        alpha: 0.2,
                                      )
                                    : BoxShadowColor.fourthColor.withValues(
                                        alpha: 0.3,
                                      ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Text(
                            'calculator_question'.tr(),
                            style: context.h1Home,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: notifier.isDark
                                ? CardColor.primaryColor
                                : CardColor.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.isDark
                                    ? BoxShadowColor.fifthColor.withValues(
                                        alpha: 0.2,
                                      )
                                    : BoxShadowColor.fourthColor.withValues(
                                        alpha: 0.3,
                                      ),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.work,
                                            size: 18,
                                            semanticLabel: 'work_icon'.tr(),
                                            color: IconColor.primaryColor,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            'app_title'.tr(),
                                            style: context.h1,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Tooltip(
                                            message: 'fgts_include_label'.tr(),
                                            triggerMode: TooltipTriggerMode.tap,
                                            preferBelow: false,
                                            verticalOffset: 20,
                                            child: Text(
                                              'include_fgts'.tr(),
                                              style: context.h1,
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Checkbox(
                                            fillColor:
                                                WidgetStateProperty.resolveWith(
                                                  (states) {
                                                    if (!states.contains(
                                                      WidgetState.selected,
                                                    )) {
                                                      return CheckColor
                                                          .primaryColor;
                                                    }
                                                    return null;
                                                  },
                                                ),
                                            side: BorderSide(
                                              color: IconColor.primaryColor,
                                              width: 2,
                                            ),
                                            value: controller.includeFgts,
                                            visualDensity:
                                                VisualDensity.compact,
                                            checkColor: IconColor.primaryColor,
                                            activeColor: notifier.isDark
                                                ? IconColor.fourthColor
                                                : IconColor.secondaryColor,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                            onChanged: (bool? value) {
                                              if (value == null) return;
                                              controller.toggleIncludeFgts(
                                                value,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(
                                  height: 15,
                                  color: notifier.isDark
                                      ? DividerColor.thirdColor
                                      : DividerColor.secondaryColor,
                                ),
                                const SizedBox(height: 16),
                                InputField(
                                  label: 'salary_clt'.tr(),
                                  controller: controller.salaryCltController,
                                  icon: Icons.attach_money_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                InputField(
                                  label: 'gross_revenue_pj'.tr(),
                                  controller: controller.salaryPjController,
                                  icon: Icons.business_center_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                Tooltip(
                                  message: 'benefits_clt_tooltip'.tr(),
                                  triggerMode: TooltipTriggerMode.tap,
                                  preferBelow: true,
                                  verticalOffset: 20,
                                  child: InputField(
                                    label: 'benefits_clt'.tr(),
                                    controller: benefitsController,
                                    icon: Icons.card_giftcard_rounded,
                                    maxWidth: maxWidth,
                                    onChanged: (_) => controller.calculate(),
                                  ),
                                ),
                                Tooltip(
                                  message: 'accountant_fee_tooltip'.tr(),
                                  triggerMode: TooltipTriggerMode.tap,
                                  preferBelow: true,
                                  verticalOffset: 20,
                                  child: InputField(
                                    label: 'accountant_fee'.tr(),
                                    controller:
                                        controller.accountantFeeController,
                                    icon: Icons.receipt_long_rounded,
                                    maxWidth: maxWidth,
                                    onChanged: (_) => controller.calculate(),
                                  ),
                                ),
                                Tooltip(
                                  message: 'inss_pj_tooltip'.tr(),
                                  triggerMode: TooltipTriggerMode.tap,
                                  preferBelow: true,
                                  verticalOffset: 20,
                                  child: InputField(
                                    label: 'inss_pj'.tr(),
                                    controller: controller.inssPjController,
                                    icon: Icons.percent_rounded,
                                    maxWidth: maxWidth,
                                    onChanged: (_) => controller.calculate(),
                                  ),
                                ),
                                Tooltip(
                                  message: 'taxes_pj_tooltip'.tr(),
                                  triggerMode: TooltipTriggerMode.tap,
                                  preferBelow: true,
                                  verticalOffset: 20,
                                  child: InputField(
                                    label: 'taxes_pj'.tr(),
                                    controller: controller.taxesPjController,
                                    icon: Icons.account_balance_rounded,
                                    maxWidth: maxWidth,
                                    onChanged: (_) => controller.calculate(),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                CustomButton(
                                  animatedGradient: true,
                                  fullWidth: true,
                                  height: 42,
                                  maxWidth: maxWidth,
                                  color: notifier.isDark
                                      ? ButtonColor.fourthColor
                                      : ButtonColor.primaryColor,
                                  onPressed: () {
                                    final controller = context
                                        .read<CalculatorController>();
                                    if (!controller.hasValidInput) {
                                      ShowDialogError.show(
                                        context,
                                        title: 'error_dialog'.tr(),
                                        child: Text(
                                          'fill_fields_to_see_chart'.tr(),
                                          style: context.bodySmall,
                                        ),
                                      );
                                      return;
                                    }
                                    onCalculatePressed();
                                  },
                                  text: 'calculate'.tr(),
                                ),
                                const SizedBox(height: 16),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton.icon(
                                    onPressed: () async {
                                      if (!controller.hasDataToClear) {
                                        ShowDialogError.show(
                                          context,
                                          title: 'error_dialog'.tr(),
                                          child: Text(
                                            'no_data_to_clear'.tr(),
                                            style: context.bodySmall,
                                          ),
                                        );
                                        return;
                                      }
                                      await controller.clearData();
                                    },
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: IconColor.primaryColor,
                                      semanticLabel: 'delete_icon'.tr(),
                                    ),
                                    label: Text(
                                      'clear_data'.tr(),
                                      style: context.footerMediumFont,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
