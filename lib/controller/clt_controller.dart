import 'dart:typed_data';
import 'package:cltvspj/models/clt_model.dart';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/services/database_service.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:cltvspj/utils/salary_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CltController extends ChangeNotifier {
  final cltSalaryController = moneyMaskedController();
  final cltBenefitsController = moneyMaskedController();

  double grossSalary = 0.0;
  double netSalary = 0.0;
  double netSalaryWithoutBenefits = 0.0;
  double inss = 0.0;
  double irrf = 0.0;
  double benefits = 0.0;
  double fgts = 0.0;

  bool get hasValidInput => netSalary > 0;

  bool includeFgts = false;

  double get netSalaryWithFgts => netSalary + fgts;

  double get netSalaryDisplay => includeFgts ? netSalary + fgts : netSalary;

  CltController() {
    _loadData();
  }

  void calculate() {
    grossSalary = cltSalaryController.numberValue;
    benefits = cltBenefitsController.numberValue;

    inss = calculateInss(grossSalary);
    irrf = calculateIrrf(grossSalary);
    fgts = calculateFgts(grossSalary);

    netSalaryWithoutBenefits = grossSalary - inss - irrf;
    netSalary = netSalaryWithoutBenefits + benefits;

    _saveData(grossSalary, benefits);
    notifyListeners();
  }

  double get employerCost {
    return grossSalary + benefits + (includeFgts ? fgts : 0);
  }

  void toggleIncludeFgts(bool value) {
    includeFgts = value;
    notifyListeners();
  }

  Future<void> _loadData() async {
    final model = await DatabaseService().loadClt();
    if (model != null) {
      cltSalaryController.updateValue(model.salaryClt);
      cltBenefitsController.updateValue(model.benefits);
      calculate();
    }
  }

  Future<void> _saveData(double salary, double benefits) async {
    final model = CltModel(salaryClt: salary, benefits: benefits);
    await DatabaseService().saveClt(model);
  }

  Future<void> exportToPdf({
    required String name,
    required String profession,
    Uint8List? chartBytes,
  }) async {
    String formatCurrency(double value) => currencyFormat.format(value);

    final bool useFgts = includeFgts;
    final String netLabel = useFgts
        ? 'net_salary_with_fgts'.tr()
        : 'net_salary'.tr();

    final double netValueToShow = netSalaryDisplay;

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

    if (useFgts) {
      summaryRows.insert(
        3,
        ReportRow(label: 'fgts'.tr(), value: formatCurrency(fgts)),
      );
    }

    summaryRows.add(
      ReportRow(label: netLabel, value: formatCurrency(netValueToShow)),
    );

    final reportData = ReportData(
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

    await generatePdfReport(reportData);
  }

  @override
  void dispose() {
    cltSalaryController.dispose();
    cltBenefitsController.dispose();
    super.dispose();
  }
}
