import 'package:cltvspj/shared/theme/app_theme.dart';
import 'package:cltvspj/shared/theme/theme_provider.dart';
import 'package:cltvspj/shared/theme/typography_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InputField extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final IconData icon;
  final double? maxWidth;
  final void Function(String)? onChanged;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType keyboardType;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;

  const InputField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hintText,
    this.maxWidth,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.keyboardType = TextInputType.number,
    this.obscureText = false,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UiProvider>(
      builder: (context, notifier, child) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: maxWidth ?? double.infinity,
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                obscureText: obscureText,
                style: context.bodySmallBold,
                onChanged: onChanged,
                inputFormatters:
                    inputFormatters ??
                    (keyboardType == TextInputType.number
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'\d+(\.\d*)?'),
                            ),
                          ]
                        : null),
                decoration: InputDecoration(
                  labelText: label,
                  hintText: hintText,
                  labelStyle: TextStyle(
                    color: TextColor.primaryColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                  hintStyle: TextStyle(
                    color: TextColor.primaryColor.withValues(alpha: 0.7),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: IconColor.primaryColor.withValues(alpha: 0.8),
                    semanticLabel: "icons_input".tr(),
                  ),
                  prefix: prefix,
                  suffix: suffix,
                  filled: true,
                  fillColor: IconColor.primaryColor.withValues(alpha: 0.05),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 15,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: notifier.isDark
                          ? BorderColor.primaryColor
                          : BorderColor.secondaryColor,
                      width: 2,
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
