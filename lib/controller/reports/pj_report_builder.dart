import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class PjReportBuilder {
  const PjReportBuilder();

  ReportData build({
    required String name,
    required String profession,
    required double grossSalary,
    required double taxValue,
    required double benefits,
    required double benefitsValue,
    required double accountantFee,
    required double inssValue,
    required double netSalary,
    Uint8List? chartBytes,
  }) {
    String formatCurrency(double value) => currencyFormat.format(value);

    final List<ReportRow> summaryRows = [
      ReportRow(
        label: 'monthly_gross_revenue'.tr(),
        value: formatCurrency(grossSalary),
      ),
      ReportRow(label: 'taxes_pj'.tr(), value: formatCurrency(taxValue)),
      ReportRow(
        label: 'accountant_fee'.tr(),
        value: formatCurrency(accountantFee),
      ),
      ReportRow(
        label: 'benefits_pj'.tr(),
        value: formatCurrency(benefitsValue),
      ),
      ReportRow(label: 'inss_pj'.tr(), value: formatCurrency(inssValue)),
      ReportRow(label: 'total_liquid'.tr(), value: formatCurrency(netSalary)),
    ];

    return ReportData(
      title: 'pj_report_title'.tr(),
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
