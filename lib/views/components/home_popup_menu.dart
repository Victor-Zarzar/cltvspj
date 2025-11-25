import 'dart:typed_data';
import 'package:cltvspj/features/app_theme.dart';
import 'package:cltvspj/views/components/show_dialog_error.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cltvspj/controller/calculator_controller.dart';

class HomePopupMenu extends StatelessWidget {
  const HomePopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_horiz,
        color: IconColor.primaryColor,
        semanticLabel: 'More Options',
      ),
      onSelected: (value) async {
        if (value == 'export_pdf') {
          final controller = context.read<CalculatorController>();
          if (!controller.hasValidInput) {
            ShowDialogError.show(
              context,
              title: 'error_dialog'.tr(),
              child: Text('fill_fields_to_see_chart'.tr()),
            );
            return;
          }

          Uint8List? chartBytes;
          // chartBytes = await _generateChartBytes();

          await controller.exportToPdf(chartBytes: chartBytes, nome: '');
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'export_pdf',
          child: ListTile(
            leading: Icon(Icons.download_outlined),
            title: Text('Gerar relatório (PDF)'),
          ),
        ),
      ],
    );
  }
}
