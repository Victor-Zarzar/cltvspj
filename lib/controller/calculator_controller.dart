import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/services/database_service.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/calculate_model.dart';
import '../utils/salary_helper.dart';

class CalculatorController extends ChangeNotifier {
  final salaryCltController = moneyMaskedController();
  final salaryPjController = moneyMaskedController();
  final benefitsController = moneyMaskedController();
  final cltBenefitsController = moneyMaskedController();
  final accountantFeeController = moneyMaskedController();

  final taxesPjController = TextEditingController();
  final inssPjController = TextEditingController();

  CalculatorModel model = CalculatorModel(
    salaryClt: 0,
    salaryPj: 0,
    benefits: 0,
    taxesPj: 0,
    accountantFee: 0,
    inssPj: 0,
  );

  double _parsePercentage(TextEditingController controller) {
    return double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0;
  }

  bool get hasValidInput =>
      salaryCltController.numberValue > 0 &&
      _parsePercentage(inssPjController) > 0 &&
      _parsePercentage(taxesPjController) > 0;

  double get difference => (totalClt - totalPj).abs();

  double get benefits => model.benefits;

  double get inss => model.salaryPj * model.inssPj;

  double get accountantFee => model.accountantFee;

  double get totalClt {
    final inss = calculateInss(model.salaryClt);
    final irrf = calculateIrrf(model.salaryClt);
    return model.salaryClt - inss - irrf + model.benefits;
  }

  double get totalPj {
    final taxPj = model.salaryPj * (model.taxesPj / 100);
    final inss = model.salaryPj * model.inssPj;
    return model.salaryPj - (taxPj + inss + model.accountantFee);
  }

  String get bestOption {
    final diff = (totalClt - totalPj).abs();
    final amountFormatted = NumberFormat.currency(
      locale: 'pt_BR',
      symbol: 'R\$',
      decimalDigits: 2,
    ).format(diff);

    if (totalClt > totalPj) {
      return 'clt_better'.tr(namedArgs: {'amount': amountFormatted});
    } else if (totalPj > totalClt) {
      return 'pj_better'.tr(namedArgs: {'amount': amountFormatted});
    } else {
      return 'perfect_tie'.tr();
    }
  }

  Future<void> loadData() async {
    model = await DatabaseService().loadCalculator() ?? model;
    salaryCltController.updateValue(model.salaryClt);
    salaryPjController.updateValue(model.salaryPj);
    benefitsController.updateValue(model.benefits);
    accountantFeeController.updateValue(model.accountantFee);
    taxesPjController.text = model.taxesPj
        .toStringAsFixed(2)
        .replaceAll('.', ',');
    inssPjController.text = (model.inssPj * 100)
        .toStringAsFixed(2)
        .replaceAll('.', ',');

    notifyListeners();
  }

  void updateValues() {
    model = CalculatorModel(
      salaryClt: salaryCltController.numberValue,
      salaryPj: salaryPjController.numberValue,
      benefits: benefitsController.numberValue,
      accountantFee: accountantFeeController.numberValue,
      taxesPj: _parsePercentage(taxesPjController),
      inssPj: _parsePercentage(inssPjController) / 100,
    );

    DatabaseService().saveCalculator(model);
    notifyListeners();
  }

  void calculate() => updateValues();

  Future<void> exportToPdf({
    required String nome,
    Uint8List? chartBytes,
  }) async {
    String formatCurrency(double value) => currencyFormat.format(value);

    final diff = (totalClt - totalPj).abs();

    final reportData = ReportData(
      title: 'pdf_title_clt_vs_pj'.tr(),
      name: nome,
      summaryRows: [
        ReportRow(
          label: 'pdf_row_clt_net'.tr(),
          value: formatCurrency(totalClt),
        ),
        ReportRow(label: 'pdf_row_pj_net'.tr(), value: formatCurrency(totalPj)),
        ReportRow(
          label: 'pdf_row_difference'.tr(),
          value: formatCurrency(diff),
        ),
      ],
      benefits: {},
      chartBytes: chartBytes,
      benefitsRows: [],
      labels: ReportLabels(
        namePrefix: 'report_name_prefix'.tr(),
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

  void disposeAll() {
    salaryCltController.dispose();
    salaryPjController.dispose();
    benefitsController.dispose();
    accountantFeeController.dispose();
    taxesPjController.dispose();
    inssPjController.dispose();
  }
}
