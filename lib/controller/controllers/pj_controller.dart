import 'dart:async';
import 'dart:typed_data';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/services/storage_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/models/pj_model.dart';
import 'package:cltvspj/controller/domain/pj_calculator.dart';
import 'package:cltvspj/controller/reports/pj_report_builder.dart';

class PjController extends ChangeNotifier {
  final salaryController = moneyMaskedController();
  final accountantController = moneyMaskedController();

  final taxController = TextEditingController();
  final inssController = TextEditingController();

  final PjCalculator _calculator;
  final PjReportBuilder _reportBuilder;

  double grossSalary = 0.0;
  double netSalary = 0.0;

  double tax = 0.0;
  double accountantFee = 189.0;
  double inss = 0.11;

  bool get hasValidInput => netSalary > 0 && tax > 0 && inss > 0;

  PjController({
    PjCalculator calculator = const PjCalculator(),
    PjReportBuilder reportBuilder = const PjReportBuilder(),
  }) : _calculator = calculator,
       _reportBuilder = reportBuilder {
    _loadData();
  }

  void calculate({bool persist = true}) {
    grossSalary = salaryController.numberValue;

    final taxPercent =
        double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0.0;
    final inssPercent =
        double.tryParse(inssController.text.replaceAll(',', '.')) ?? 0.0;

    accountantFee = accountantController.numberValue;

    final result = _calculator.calculate(
      PjCalculationInput(
        grossSalary: grossSalary,
        taxPercent: taxPercent,
        inssPercent: inssPercent,
        accountantFee: accountantFee,
      ),
    );

    tax = result.taxValue;
    inss = result.inssValue;
    netSalary = result.netSalary;

    if (persist) {
      _saveData(grossSalary, taxPercent, accountantFee, inssPercent);
    }

    notifyListeners();
  }

  Future<void> _loadData() async {
    final model = await StorageService().loadPj();

    if (model != null) {
      salaryController.updateValue(model.grossSalary);
      accountantController.updateValue(model.accountantFee);
      taxController.text = model.taxes.toStringAsFixed(2);
      inssController.text = model.inss.toStringAsFixed(2);
    } else {
      salaryController.updateValue(0);
      accountantController.updateValue(189.0);
      taxController.text = '0';
      inssController.text = '0';
    }

    calculate(persist: false);
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
    await StorageService().savePj(model);
  }

  Future<void> clearData() async {
    salaryController.updateValue(0);
    accountantController.updateValue(0);
    taxController.text = '0';
    inssController.text = '0';

    grossSalary = 0.0;
    netSalary = 0.0;
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
    inssController.dispose();
    super.dispose();
  }
}
