import 'dart:async';
import 'dart:typed_data';
import 'package:cltvspj/core/utils/currency_format_helper.dart';
import 'package:cltvspj/features/pj/domain/entities/pj_entity.dart';
import 'package:cltvspj/features/pj/domain/pj_calculator.dart';
import 'package:cltvspj/features/pj/presentation/reports/pj_report_builder.dart';
import 'package:cltvspj/shared/services/export_service.dart';
import 'package:cltvspj/shared/services/storage_service.dart';
import 'package:flutter/material.dart';

class PjViewModel extends ChangeNotifier {
  final salaryController = TextEditingController();
  final accountantController = TextEditingController();
  final benefitsController = TextEditingController();

  final taxController = TextEditingController();
  final inssController = TextEditingController();

  final PjCalculator _calculator;
  final PjReportBuilder _reportBuilder;

  double grossSalary = 0.0;
  double netSalary = 0.0;
  double benefits = 0.0;
  double tax = 0.0;
  double accountantFee = 189.0;
  double inss = 0.11;

  bool get hasValidInput {
    final salary = parseBrlToDouble(salaryController.text);

    final taxPercent =
        double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0.0;

    final inssPercent =
        double.tryParse(inssController.text.replaceAll(',', '.')) ?? 0.0;

    return salary > 0 && taxPercent > 0 && inssPercent > 0;
  }

  PjViewModel({
    PjCalculator calculator = const PjCalculator(),
    PjReportBuilder reportBuilder = const PjReportBuilder(),
  }) : _calculator = calculator,
       _reportBuilder = reportBuilder {
    _loadData();
  }

  void calculate({bool persist = true}) {
    grossSalary = parseBrlToDouble(salaryController.text);

    final taxPercent =
        double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0.0;
    final inssPercent =
        double.tryParse(inssController.text.replaceAll(',', '.')) ?? 0.0;

    final benefitsValue = parseBrlToDouble(benefitsController.text);

    accountantFee = parseBrlToDouble(accountantController.text);

    final result = _calculator.calculate(
      PjCalculationInput(
        grossSalary: grossSalary,
        taxPercent: taxPercent,
        benefitsValue: benefitsValue,
        inssPercent: inssPercent,
        accountantFee: accountantFee,
      ),
    );

    tax = result.taxValue;
    inss = result.inssValue;
    benefits = result.benefitsValue;
    netSalary = result.netSalary;

    if (persist) {
      _saveData(
        grossSalary,
        taxPercent,
        benefitsValue,
        accountantFee,
        inssPercent,
      );
    }

    notifyListeners();
  }

  Future<void> _loadData() async {
    final model = await StorageService().loadPj();

    if (model != null) {
      salaryController.text = formatCurrency(model.grossSalary);
      accountantController.text = formatCurrency(model.accountantFee);
      benefitsController.text = formatCurrency(model.benefits);
      taxController.text = model.taxes.toStringAsFixed(2);
      inssController.text = model.inss.toStringAsFixed(2);
    } else {
      salaryController.text = formatCurrency(0);
      accountantController.text = formatCurrency(189.0);
      benefitsController.text = formatCurrency(0);
      taxController.text = '0';
      inssController.text = '0';
    }

    calculate(persist: false);
  }

  Future<void> _saveData(
    double grossSalary,
    double taxPercent,
    double benefits,
    double accountant,
    double inssPercent,
  ) async {
    final model = PjEntity(
      grossSalary: grossSalary,
      taxes: taxPercent,
      benefits: benefits,
      accountantFee: accountant,
      inss: inssPercent,
    );
    await StorageService().savePj(model);
  }

  bool get hasDataToClear {
    final salary = parseBrlToDouble(salaryController.text);
    final accountant = parseBrlToDouble(accountantController.text);
    final taxText = taxController.text.trim();
    final inssText = inssController.text.trim();
    final taxValue = double.tryParse(taxText.replaceAll(',', '.')) ?? 0.0;
    final inssValue = double.tryParse(inssText.replaceAll(',', '.')) ?? 0.0;
    final benefitsValue = parseBrlToDouble(benefitsController.text);

    final hasAnyInput =
        salary > 0 ||
        accountant > 0 ||
        taxValue > 0 ||
        inssValue > 0 ||
        benefitsValue > 0;

    final hasAnyComputed =
        grossSalary != 0.0 ||
        netSalary != 0.0 ||
        benefits != 0.0 ||
        tax != 0.0 ||
        accountantFee != 0.0 ||
        inss != 0.0;

    return hasAnyInput || hasAnyComputed;
  }

  Future<void> clearData() async {
    salaryController.text = formatCurrency(0);
    accountantController.text = formatCurrency(0);
    benefitsController.text = formatCurrency(0);
    taxController.text = '0';
    inssController.text = '0';

    grossSalary = 0.0;
    netSalary = 0.0;
    benefits = 0.0;
    tax = 0.0;
    accountantFee = 0.0;
    inss = 0.0;

    await StorageService().clearPj();
    notifyListeners();
  }

  Future<void> exportToPdf({
    required String name,
    required String profession,
    Uint8List? chartBytes,
  }) async {
    final reportData = _reportBuilder.build(
      name: name,
      profession: profession,
      grossSalary: grossSalary,
      benefits: benefits,
      benefitsValue: benefits,
      taxValue: tax,
      accountantFee: accountantFee,
      inssValue: inss,
      netSalary: netSalary,
      chartBytes: chartBytes,
    );

    await generatePdfReport(reportData);
  }

  @override
  void dispose() {
    salaryController.dispose();
    accountantController.dispose();
    taxController.dispose();
    benefitsController.dispose();
    inssController.dispose();
    super.dispose();
  }
}
