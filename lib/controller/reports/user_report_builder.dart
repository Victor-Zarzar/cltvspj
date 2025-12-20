import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class UserReportBuilder {
  const UserReportBuilder();

  ReportData build({
    required String name,
    required String profession,
    required double salary,
    required double benefits,
    Uint8List? chartBytes,
  }) {
    String formatCurrency(double value) => currencyFormat.format(value);

    return ReportData(
      title: 'user_report_title'.tr(),
      name: name,
      profession: profession,
      summaryRows: [
        ReportRow(label: 'name'.tr(), value: name),
        ReportRow(label: 'profession'.tr(), value: profession),
        ReportRow(label: 'salary'.tr(), value: formatCurrency(salary)),
        ReportRow(label: 'benefits'.tr(), value: formatCurrency(benefits)),
      ],
      benefits: {'benefits'.tr(): benefits},
      chartBytes: chartBytes,
      benefitsRows: [],
      labels: ReportLabels(
        namePrefix: 'report_name_prefix'.tr(),
        professionPrefix: 'report_professions_prefix'.tr(),
        benefitsTitle: 'report_benefits_title'.tr(),
        chartTitle: 'report_chart_title'.tr(),
        tableHeaders: [
          'report_table_header_type'.tr(),
          'report_table_header_value'.tr(),
        ],
      ),
    );
  }
}
