import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class CalculatorReportBuilder {
  const CalculatorReportBuilder();

  ReportData build({
    required String name,
    required String profession,
    required double totalClt,
    required double totalPj,
    required double differenceAbs,
    Uint8List? chartBytes,
  }) {
    String formatCurrency(double value) => currencyFormat.format(value);

    return ReportData(
      title: 'pdf_title_clt_vs_pj'.tr(),
      name: name,
      profession: profession,
      summaryRows: [
        ReportRow(
          label: 'pdf_row_clt_net'.tr(),
          value: formatCurrency(totalClt),
        ),
        ReportRow(label: 'pdf_row_pj_net'.tr(), value: formatCurrency(totalPj)),
        ReportRow(
          label: 'pdf_row_difference'.tr(),
          value: formatCurrency(differenceAbs),
        ),
      ],
      benefits: const {},
      chartBytes: chartBytes,
      benefitsRows: [],
      labels: ReportLabels(
        namePrefix: 'report_name_prefix'.tr(),
        professionPrefix: 'report_profession_prefix'.tr(),
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
