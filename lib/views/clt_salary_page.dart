import 'package:cltvspj/controller/clt_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:cltvspj/views/components/clt_popup_menu.dart';
import 'package:cltvspj/views/components/custom_button.dart';
import 'package:cltvspj/views/components/input_field.dart';
import 'package:cltvspj/views/components/result_clt_dialog.dart';
import 'package:cltvspj/views/components/show_dialog_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Cltpage extends StatefulWidget {
  const Cltpage({super.key});

  @override
  State<Cltpage> createState() => _CltpageState();
}

class _CltpageState extends State<Cltpage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Scaffold(
          backgroundColor: notifier.isDark
              ? BackGroundColor.fourthColor
              : BackGroundColor.primaryColor,
          appBar: AppBar(
            title: Text("clt_title".tr(), style: context.h1),
            actions: const [CltPopupMenu()],
            centerTitle: true,
            backgroundColor: notifier.isDark
                ? AppBarColor.thirdColor
                : AppBarColor.secondaryColor,
          ),
          body: Responsive(
            mobile: _buildContent(
              context,
              maxWidth: 370,
              padding: 20,
              minHeight: 550,
            ),
            tablet: _buildContent(
              context,
              maxWidth: 600,
              padding: 30,
              minHeight: 600,
            ),
            desktop: _buildContent(
              context,
              maxWidth: 700,
              minHeight: 560,
              padding: 50,
            ),
          ),
        );
      },
    );
  }
}

Widget _buildContent(
  BuildContext context, {
  required double maxWidth,
  required double padding,
  required double minHeight,
}) {
  return Consumer2<UiProvider, CltController>(
    builder: (context, notifier, controller, child) {
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth, minHeight: minHeight),
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: SingleChildScrollView(
                child: Column(
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
                          children: [
                            InputField(
                              label: 'salary_clt'.tr(),
                              controller: controller.cltSalaryController,
                              icon: Icons.attach_money_rounded,
                              maxWidth: maxWidth,
                              onChanged: (_) => controller.calculate(),
                            ),
                            InputField(
                              label: 'benefits_clt'.tr(),
                              controller: controller.cltBenefitsController,
                              icon: Icons.card_giftcard_rounded,
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
                        final controller = context.read<CltController>();

                        if (controller.hasValidInput) {
                          ResultCltDialog.show(context, currencyFormat);
                        } else {
                          ShowDialogError.show(
                            context,
                            title: 'error_dialog'.tr(),
                            child: Text('fill_fields_to_see_chart'.tr()),
                          );
                        }
                      },
                      text: 'calculate'.tr(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}
