import 'dart:typed_data';
import 'package:cltvspj/features/clt/presentantion/viewmodels/clt_viewmodel.dart';
import 'package:cltvspj/features/user/presentation/viewmodels/user_viewmodel.dart';
import 'package:cltvspj/shared/theme/app_theme.dart';
import 'package:cltvspj/shared/theme/typography_extension.dart';
import 'package:cltvspj/shared/widgets/show_dialog_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CltPopupMenu extends StatelessWidget {
  const CltPopupMenu({super.key});

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
          final controller = context.read<CltViewModel>();
          final userController = context.read<UserViewModel>();

          final userName = userController.userName;
          final profession = userController.professionName;

          if (!controller.hasValidInput) {
            ShowDialogError.show(
              context,
              title: 'error_dialog'.tr(),
              child: Text('report_error'.tr(), style: context.h2Dialog),
            );
            return;
          }

          if (!userController.hasLoadedOnce) {
            await userController.loadUser();
          }

          Uint8List? chartBytes;
          // chartBytes = await _generateChartBytes();

          await controller.exportToPdf(
            chartBytes: chartBytes,
            name: userName,
            profession: profession,
          );
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
            title: Text('generate_report'.tr(), style: context.h2Dialog),
          ),
        ),
      ],
    );
  }
}
