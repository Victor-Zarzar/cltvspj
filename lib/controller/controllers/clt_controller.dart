import 'dart:typed_data';
import 'package:cltvspj/models/clt_model.dart';
import 'package:cltvspj/services/database_service.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/controller/domain/clt_calculator.dart';
import 'package:cltvspj/controller/reports/clt_report_builder.dart';

class CltController extends ChangeNotifier {
  final cltSalaryController = moneyMaskedController();
  final cltBenefitsController = moneyMaskedController();

  final CltCalculator _calculator;
  final CltReportBuilder _reportBuilder;

  double grossSalary = 0.0;
  double netSalary = 0.0;
  double netSalaryWithoutBenefits = 0.0;
  double inss = 0.0;
  double irrf = 0.0;
  double benefits = 0.0;
  double fgts = 0.0;

  bool get hasValidInput => netSalary > 0;

  bool get hasAnyData {
    return cltSalaryController.numberValue > 0 ||
        cltBenefitsController.numberValue > 0;
  }

  bool get isEmpty => !hasAnyData;

  bool includeFgts = false;

  double get netSalaryWithFgts => netSalary + fgts;
  double get netSalaryDisplay => includeFgts ? netSalary + fgts : netSalary;

  CltController({
    CltCalculator calculator = const CltCalculator(),
    CltReportBuilder reportBuilder = const CltReportBuilder(),
  }) : _calculator = calculator,
       _reportBuilder = reportBuilder {
    _loadData();
  }

  void calculate({bool persist = true}) {
    grossSalary = cltSalaryController.numberValue;
    benefits = cltBenefitsController.numberValue;

    final result = _calculator.calculate(
      grossSalary: grossSalary,
      benefits: benefits,
    );

    inss = result.inss;
    irrf = result.irrf;
    fgts = result.fgts;
    netSalaryWithoutBenefits = result.netSalaryWithoutBenefits;
    netSalary = result.netSalary;

    if (persist) {
      _saveData(grossSalary, benefits);
    }

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
      calculate(persist: false);
    }
  }

  Future<void> _saveData(double salary, double benefits) async {
    final model = CltModel(salaryClt: salary, benefits: benefits);
    await DatabaseService().saveClt(model);
  }

  Future<void> clearData() async {
    cltSalaryController.updateValue(0);
    cltBenefitsController.updateValue(0);
    grossSalary = 0.0;
    netSalary = 0.0;
    netSalaryWithoutBenefits = 0.0;
    inss = 0.0;
    irrf = 0.0;
    benefits = 0.0;
    fgts = 0.0;
    includeFgts = false;

    await DatabaseService().clearClt();
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
      inss: inss,
      irrf: irrf,
      fgts: fgts,
      netSalaryWithoutBenefits: netSalaryWithoutBenefits,
      benefits: benefits,
      netSalaryToShow: netSalaryDisplay,
      includeFgts: includeFgts,
      chartBytes: chartBytes,
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
