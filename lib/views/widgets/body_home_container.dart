import 'package:cltvspj/controller/calculator_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
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
                          decoration: BoxDecoration(
                            color: notifier.isDark
                                ? CardColor.primaryColor
                                : CardColor.secondaryColor,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: notifier.isDark
                                    ? Colors.black.withValues(alpha: 0.3)
                                    : Colors.grey.withValues(alpha: 0.2),
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
                                InputField(
                                  label: 'salary_clt'.tr(),
                                  controller: controller.salaryCltController,
                                  icon: Icons.attach_money_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                InputField(
                                  label: 'salary_pj'.tr(),
                                  controller: controller.salaryPjController,
                                  icon: Icons.business_center_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                InputField(
                                  label: 'benefits_clt'.tr(),
                                  controller: benefitsController,
                                  icon: Icons.card_giftcard_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                InputField(
                                  label: 'accountant_fee'.tr(),
                                  controller:
                                      controller.accountantFeeController,
                                  icon: Icons.receipt_long_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                InputField(
                                  label: 'inss_pj'.tr(),
                                  controller: controller.inssPjController,
                                  icon: Icons.percent_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                                InputField(
                                  label: 'taxes_pj'.tr(),
                                  controller: controller.taxesPjController,
                                  icon: Icons.account_balance_rounded,
                                  maxWidth: maxWidth,
                                  onChanged: (_) => controller.calculate(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                                child: Text('fill_fields_to_see_chart'.tr()),
                              );
                              return;
                            }
                            onCalculatePressed();
                          },
                          text: 'calculate'.tr(),
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
