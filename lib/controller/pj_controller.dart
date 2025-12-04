import 'dart:async';
import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/services/database_service.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/models/pj_model.dart';

class PjController extends ChangeNotifier {
  final salaryController = moneyMaskedController();
  final accountantController = moneyMaskedController();

  final taxController = TextEditingController();
  final inssController = TextEditingController();

  double grossSalary = 0.0;
  double netSalary = 0.0;
  double tax = 0.0;
  double accountantFee = 189.0;
  double inss = 0.11;

  bool get hasValidInput => netSalary > 0 && tax > 0 && inss > 0;

  PjController() {
    _loadData();
  }

  void calculate() {
    final grossSalary = salaryController.numberValue;

    final taxPercent =
        double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0.0;
    final inssPercent =
        double.tryParse(inssController.text.replaceAll(',', '.')) ?? 0.0;

    accountantFee = accountantController.numberValue;
    tax = grossSalary * (taxPercent / 100);
    inss = grossSalary * (inssPercent / 100);

    final totalDiscount = tax + inss + accountantFee;
    netSalary = grossSalary - totalDiscount;

    _saveData(grossSalary, taxPercent, accountantFee, inssPercent);
    notifyListeners();
  }

  Future<void> _loadData() async {
    final model = await DatabaseService().loadPj();
    if (model != null) {
      salaryController.updateValue(model.grossSalary);
      accountantController.updateValue(model.accountantFee);
      taxController.text = model.taxes.toStringAsFixed(0);
      inssController.text = model.inss.toStringAsFixed(0);
      calculate();
    }
  }

  Future<void> _saveData(
    double grossSalary,
    double taxPercent,
    double accountant,
    double inssPercent,
  ) async {
    final model = PjModel(
      grossSalary: grossSalary,
      taxes: taxPercent,
      accountantFee: accountant,
      inss: inssPercent,
    );
    await DatabaseService().savePj(model);
  }

  Future<void> exportToPdf({
    required String name,
    required String profession,
    Uint8List? chartBytes,
  }) async {
    String formatCurrency(double value) => currencyFormat.format(value);

    final grossSalary = salaryController.numberValue;

    final reportData = ReportData(
      title: 'pj_report_title'.tr(),
      name: name,
      profession: profession,
      summaryRows: [
        ReportRow(label: 'salary_pj'.tr(), value: formatCurrency(grossSalary)),
        ReportRow(label: 'taxes_pj'.tr(), value: formatCurrency(tax)),
        ReportRow(
          label: 'accountant_fee'.tr(),
          value: formatCurrency(accountantFee),
        ),
        ReportRow(label: 'inss_pj'.tr(), value: formatCurrency(inss)),
        ReportRow(label: 'net_salary'.tr(), value: formatCurrency(netSalary)),
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

    await generatePdfReport(reportData);
  }

  @override
  void dispose() {
    salaryController.dispose();
    accountantController.dispose();
    taxController.dispose();
    inssController.dispose();
    super.dispose();
  }
}
