import 'package:cltvspj/features/responsive_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ShowDialogError {
  static Future<void> show(
    BuildContext context, {
    required Widget child,
    String? title,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(context).dialogBackgroundColor,
          title: title != null ? Text(title) : null,
          content: child,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('close'.tr(), style: context.bodySmallDarkBold),
            ),
          ],
        );
      },
    );
  }
}
