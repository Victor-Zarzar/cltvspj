import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class CltReportBuilder {
  const CltReportBuilder();

  ReportData build({
    required String name,
    required String profession,
    required double grossSalary,
    required double inss,
    required double irrf,
    required double fgts,
    required double netSalaryWithoutBenefits,
    required double benefits,
    required double netSalaryToShow,
    required bool includeFgts,
    Uint8List? chartBytes,
  }) {
    String formatCurrency(double value) => currencyFormat.format(value);

    final String netLabel = includeFgts
        ? 'net_salary_with_fgts'.tr()
        : 'net_salary'.tr();

    final List<ReportRow> summaryRows = [
      ReportRow(label: 'salary_clt'.tr(), value: formatCurrency(grossSalary)),
      ReportRow(label: 'inss'.tr(), value: formatCurrency(inss)),
      ReportRow(label: 'irrf'.tr(), value: formatCurrency(irrf)),
      ReportRow(
        label: 'net_salary_discounts'.tr(),
        value: formatCurrency(netSalaryWithoutBenefits),
      ),
      ReportRow(label: 'benefits_clt'.tr(), value: formatCurrency(benefits)),
    ];

    if (includeFgts) {
      summaryRows.insert(
        3,
        ReportRow(label: 'fgts'.tr(), value: formatCurrency(fgts)),
      );
    }

    summaryRows.add(
      ReportRow(label: netLabel, value: formatCurrency(netSalaryToShow)),
    );

    return ReportData(
      title: 'clt_report_title'.tr(),
      name: name,
      profession: profession,
      summaryRows: summaryRows,
      benefits: {'benefits_clt'.tr(): benefits},
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
