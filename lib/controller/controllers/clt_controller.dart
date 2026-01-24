import 'dart:typed_data';
import 'package:cltvspj/models/clt_model.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/services/storage_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/controller/domain/clt_calculator.dart';
import 'package:cltvspj/controller/reports/clt_report_builder.dart';
import 'package:easy_localization/easy_localization.dart';

class CltController extends ChangeNotifier {
  final cltSalaryController = TextEditingController();
  final cltBenefitsController = TextEditingController();

  final CltCalculator _calculator;
  final CltReportBuilder _reportBuilder;

  double grossSalary = 0.0;
  double benefits = 0.0;
  double inss = 0.0;
  double irrf = 0.0;
  double netSalaryWithoutBenefits = 0.0;
  double netSalaryBase = 0.0;
  double fgtsValue = 0.0;

  bool includeFgts = false;

  bool get hasValidInput => netSalaryBase > 0;

  bool get hasAnyData =>
      parseBrlToDouble(cltSalaryController.text) > 0 ||
      parseBrlToDouble(cltBenefitsController.text) > 0;

  bool get isEmpty => !hasAnyData;

  double get netSalaryToShow => netSalaryBase + (includeFgts ? fgtsValue : 0.0);

  String get netSalaryLabelToShow =>
      includeFgts ? 'net_salary_with_fgts'.tr() : 'net_salary'.tr();

  double get employerCost =>
      grossSalary + benefits + (includeFgts ? fgtsValue : 0.0);

  CltController({
    CltCalculator calculator = const CltCalculator(),
    CltReportBuilder reportBuilder = const CltReportBuilder(),
  }) : _calculator = calculator,
       _reportBuilder = reportBuilder {
    _loadData();
  }

  void calculate({bool persist = true}) {
    grossSalary = parseBrlToDouble(cltSalaryController.text);
    benefits = parseBrlToDouble(cltBenefitsController.text);

    final result = _calculator.calculate(
      grossSalary: grossSalary,
      benefits: benefits,
    );

    inss = result.inss;
    irrf = result.irrf;
    fgtsValue = result.fgts;
    netSalaryWithoutBenefits = result.netSalaryWithoutBenefits;
    netSalaryBase = result.netSalary;

    if (persist) {
      _saveData(grossSalary, benefits);
    }

    notifyListeners();
  }

  void toggleIncludeFgts(bool value) {
    includeFgts = value;
    notifyListeners();
  }

  Future<void> _loadData() async {
    final model = await StorageService().loadClt();
    if (model != null) {
      cltSalaryController.text = formatCurrency(model.salaryClt);
      cltBenefitsController.text = formatCurrency(model.benefits);
    } else {
      cltSalaryController.text = formatCurrency(0);
      cltBenefitsController.text = formatCurrency(0);
    }
    calculate(persist: false);
  }

  Future<void> _saveData(double salary, double benefits) async {
    final model = CltModel(salaryClt: salary, benefits: benefits);
    await StorageService().saveClt(model);
  }

  bool get hasDataToClear {
    final salary = parseBrlToDouble(cltSalaryController.text);
    final benefits = parseBrlToDouble(cltBenefitsController.text);

    final hasAnyInput = salary > 0 || benefits > 0;
    final hasAnyComputed =
        grossSalary != 0.0 ||
        benefits != 0.0 ||
        inss != 0.0 ||
        irrf != 0.0 ||
        netSalaryWithoutBenefits != 0.0 ||
        netSalaryBase != 0.0 ||
        fgtsValue != 0.0;

    return hasAnyInput || hasAnyComputed;
  }

  Future<void> clearData() async {
    cltSalaryController.text = formatCurrency(0);
    cltBenefitsController.text = formatCurrency(0);
    grossSalary = 0.0;
    benefits = 0.0;
    inss = 0.0;
    irrf = 0.0;
    netSalaryWithoutBenefits = 0.0;
    netSalaryBase = 0.0;
    fgtsValue = 0.0;
    includeFgts = false;

    await StorageService().clearClt();
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
      fgts: fgtsValue,
      netSalaryWithoutBenefits: netSalaryWithoutBenefits,
      benefits: benefits,
      netSalaryToShow: netSalaryToShow,
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
