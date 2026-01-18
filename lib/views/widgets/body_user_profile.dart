import 'package:cltvspj/controller/controllers/user_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyUserProfile extends StatelessWidget {
  final UserController controller;

  const BodyUserProfile({super.key, required this.controller});

  bool get _hasAnyValue {
    final hasName = controller.nameController.text.trim().isNotEmpty;
    final hasProfession = controller.professionController.text
        .trim()
        .isNotEmpty;

    final hasSalary = !isZeroOrEmptyCurrency(controller.salaryController.text);
    final hasBenefits = !isZeroOrEmptyCurrency(
      controller.benefitsController.text,
    );

    return hasName || hasProfession || hasSalary || hasBenefits;
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAnyValue) {
      return const SizedBox.shrink();
    }

    return Consumer2<UiProvider, UserController>(
      builder: (context, notifier, userController, child) {
        return Card(
          color: notifier.isDark
              ? CardColor.primaryColor
              : CardColor.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Semantics(
              label: 'arrow_icon'.tr(),
              hint: 'expand_or_collapse'.tr(),
              child: ExpansionTile(
                collapsedIconColor: IconColor.primaryColor,
                iconColor: IconColor.primaryColor,
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                childrenPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                title: Text(
                  'user_profile_saved_header'.tr(),
                  style: context.bodyMediumFont,
                ),
                subtitle: Text(
                  'user_profile_saved_subtitle'.tr(),
                  style: context.bodyMediumFont,
                ),
                children: [
                  _buildRow(
                    context,
                    label: 'user_name_label'.tr(),
                    value: controller.nameController.text,
                  ),
                  _buildRow(
                    context,
                    label: 'user_salary_label'.tr(),
                    value: controller.salaryController.text,
                    isMoney: true,
                  ),
                  _buildRow(
                    context,
                    label: 'user_benefits_label'.tr(),
                    value: controller.benefitsController.text,
                    isMoney: true,
                  ),
                  _buildRow(
                    context,
                    label: 'user_profession_label'.tr(),
                    value: controller.professionController.text,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isMoney = false,
  }) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    if (isMoney && isZeroOrEmptyCurrency(value)) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Expanded(flex: 4, child: Text(label, style: context.h1)),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: context.bodyMediumFont,
            ),
          ),
        ],
      ),
    );
  }
}
