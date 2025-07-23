import 'package:cltvspj/model/clt_model.dart';
import 'package:cltvspj/services/database_service.dart';
import 'package:cltvspj/utils/salary_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class CltController extends ChangeNotifier {
  final cltSalaryController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final cltBenefitsController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  double netSalary = 0.0;
  double inss = 0.0;
  double irrf = 0.0;
  double benefits = 0.0;

  bool get hasValidInput => netSalary > 0;

  CltController() {
    _loadData();
  }

  void calculate() {
    final salary = cltSalaryController.numberValue;
    benefits = cltBenefitsController.numberValue;

    inss = calculateInss(salary);
    irrf = calculateIrrf(salary);
    netSalary = salary - inss - irrf + benefits;

    _saveData(salary, benefits);
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

  @override
  void dispose() {
    cltSalaryController.dispose();
    cltBenefitsController.dispose();
    super.dispose();
  }
}
