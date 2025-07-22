import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/features/theme_provider.dart';
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
              ? BackGroundColor.fourthColor
              : BackGroundColor.primaryColor,
          title: Text(title ?? defaultTitle, style: context.h1),
          content: child,
          contentTextStyle: context.h2,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('close'.tr(), style: context.footerMediumFont),
            ),
          ],
        );
      },
    );
  }
}
