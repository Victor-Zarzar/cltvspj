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
    required bool includeFgts,
    required double fgts,
    required double inssPj,
    required double benefits,
    required double taxesPjPercent,
    required double accountantFee,
    Uint8List? chartBytes,
  }) {
    String formatCurrency(double value) => currencyFormat.format(value);

    final List<ReportRow> summaryRows = [
      ReportRow(label: 'pdf_row_clt_net'.tr(), value: formatCurrency(totalClt)),
      if (includeFgts)
        ReportRow(label: 'fgts'.tr(), value: formatCurrency(fgts)),
      ReportRow(label: 'benefits_clt'.tr(), value: formatCurrency(benefits)),
      ReportRow(label: 'inss_pj'.tr(), value: formatCurrency(inssPj)),
      ReportRow(label: 'taxes_pj'.tr(), value: formatCurrency(taxesPjPercent)),
      ReportRow(
        label: 'accountant_fee'.tr(),
        value: formatCurrency(accountantFee),
      ),
      ReportRow(label: 'pdf_row_pj_net'.tr(), value: formatCurrency(totalPj)),
      ReportRow(
        label: 'pdf_row_difference'.tr(),
        value: formatCurrency(differenceAbs),
      ),
    ];

    return ReportData(
      title: 'pdf_title_clt_vs_pj'.tr(),
      name: name,
      profession: profession,
      summaryRows: summaryRows,
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
