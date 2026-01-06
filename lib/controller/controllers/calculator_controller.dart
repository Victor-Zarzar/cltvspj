import 'dart:typed_data';
import 'package:cltvspj/services/database_service.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/models/calculate_model.dart';
import 'package:cltvspj/controller/domain/calculator_engine.dart';
import 'package:cltvspj/controller/reports/calculator_report_builder.dart';

class CalculatorController extends ChangeNotifier {
  final salaryCltController = moneyMaskedController();
  final salaryPjController = moneyMaskedController();
  final benefitsController = moneyMaskedController();
  final cltBenefitsController = moneyMaskedController();
  final accountantFeeController = moneyMaskedController();

  final taxesPjController = TextEditingController();
  final inssPjController = TextEditingController();

  final CalculatorEngine _engine;
  final CalculatorReportBuilder _reportBuilder;

  CalculatorModel model = CalculatorModel(
    salaryClt: 0,
    salaryPj: 0,
    benefits: 0,
    taxesPj: 0,
    accountantFee: 189.0,
    inssPj: 0.11,
  );

  CalculatorController({
    CalculatorEngine engine = const CalculatorEngine(),
    CalculatorReportBuilder reportBuilder = const CalculatorReportBuilder(),
  }) : _engine = engine,
       _reportBuilder = reportBuilder;

  double _parsePercentage(TextEditingController controller) {
    return double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0;
  }

  bool get hasValidInput =>
      salaryCltController.numberValue > 0 &&
      _parsePercentage(inssPjController) > 0 &&
      _parsePercentage(taxesPjController) > 0;

  double get benefits => model.benefits;
  double get inss => model.salaryPj * model.inssPj;
  double get accountantFee => model.accountantFee;
  double get totalCltBase =>
      _engine.totalClt(salaryClt: model.salaryClt, benefits: model.benefits);

  double get totalPj => _engine.totalPj(
    salaryPj: model.salaryPj,
    taxesPjPercent: model.taxesPj,
    inssPjRate: model.inssPj,
    accountantFee: model.accountantFee,
  );

  bool includeFgts = false;

  double get fgtsValue => model.salaryClt * 0.08;

  double get totalCltToShow => totalCltBase + (includeFgts ? fgtsValue : 0.0);

  double get differenceToShow => (totalCltToShow - totalPj).abs();

  String get bestOption {
    final amountFormatted = currencyFormat.format(differenceToShow);

    return _engine
        .evaluate(
          salaryClt: model.salaryClt,
          benefits: model.benefits,
          salaryPj: model.salaryPj,
          taxesPjPercent: model.taxesPj,
          inssPjRate: model.inssPj,
          accountantFee: model.accountantFee,
          amountFormatted: amountFormatted,
        )
        .bestOptionText;
  }

  void toggleIncludeFgts(bool value) {
    includeFgts = value;
    notifyListeners();
  }

  Future<void> loadData() async {
    final model = await DatabaseService().loadCalculator();

    if (model != null) {
      salaryCltController.updateValue(model.salaryClt);
      salaryPjController.updateValue(model.salaryPj);
      benefitsController.updateValue(model.benefits);
      accountantFeeController.updateValue(model.accountantFee);
      inssPjController.text = (model.inssPj * 100)
          .toStringAsFixed(2)
          .replaceAll('.', ',');
      taxesPjController.text = model.taxesPj
          .toStringAsFixed(2)
          .replaceAll('.', ',');
    } else {
      salaryCltController.updateValue(0);
      salaryPjController.updateValue(0);
      benefitsController.updateValue(0);
      accountantFeeController.updateValue(189.0);
      inssPjController.text = '0';
      taxesPjController.text = '0';
    }

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

  Future<void> clearData() async {
    salaryCltController.updateValue(0);
    salaryPjController.updateValue(0);
    benefitsController.updateValue(0);
    cltBenefitsController.updateValue(0);
    accountantFeeController.updateValue(0);
    taxesPjController.text = '0';
    inssPjController.text = '0';
    includeFgts = false;

    model = CalculatorModel(
      salaryClt: 0.0,
      salaryPj: 0.0,
      benefits: 0.0,
      taxesPj: 0.0,
      accountantFee: 0.0,
      inssPj: 0.0,
    );

    await DatabaseService().clearCalculator();
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
      totalClt: totalCltToShow,
      totalPj: totalPj,
      differenceAbs: differenceToShow,
      includeFgts: includeFgts,
      fgts: fgtsValue,
      benefits: benefits,
      inssPj: inss,
      taxesPjPercent: model.taxesPj,
      accountantFee: model.accountantFee,
      chartBytes: chartBytes,
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
