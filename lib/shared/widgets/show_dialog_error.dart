import 'package:cltvspj/shared/theme/app_theme.dart';
import 'package:cltvspj/shared/theme/theme_provider.dart';
import 'package:cltvspj/shared/theme/typography_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowDialogError {
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    String? title,
  }) {
    final notifier = Provider.of<UiProvider>(context, listen: false);
    final defaultTitle = 'error_dialog'.tr();

    return showDialog(
      context: context,
      builder: (ctx) {
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
          title: Text(title ?? defaultTitle, style: context.h1Dialog),
          content: child,
          contentTextStyle: context.h2Dialog,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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
}
