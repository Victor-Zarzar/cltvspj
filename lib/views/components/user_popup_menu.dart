import 'dart:typed_data';
import 'package:cltvspj/controller/user_controller.dart';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/features/responsive_extension.dart';
import 'package:cltvspj/views/components/show_dialog_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPopupMenu extends StatelessWidget {
  const UserPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        color: IconColor.primaryColor,
        semanticLabel: 'more_options'.tr(),
      ),
      onSelected: (value) async {
        if (value == 'export_pdf') {
          final controller = context.read<UserController>();

          if (!controller.hasValidInput) {
            ShowDialogError.show(
              context,
              title: 'error_dialog'.tr(),
              child: Text('report_error'.tr(), style: context.h2Dialog),
            );
            return;
          }
          Uint8List? chartBytes;
          // chartBytes = await _generateChartBytes();

          await controller.exportToPdf(chartBytes: chartBytes, nome: '');
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'export_pdf',
          child: ListTile(
            leading: Icon(
              Icons.download,
              color: IconColor.primaryColor,
              size: 22,
              semanticLabel: 'download_icon'.tr(),
            ),
            title: Text('generate_report'.tr(), style: context.h1),
          ),
        ),
      ],
    );
  }
}
