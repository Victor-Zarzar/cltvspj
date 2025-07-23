import 'dart:async';
import 'package:cltvspj/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:cltvspj/model/pj_model.dart';

class PjController extends ChangeNotifier {
  final salaryController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final accountantController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
    initialValue: 189.0,
  );

  final taxController = TextEditingController();
  final inssController = TextEditingController();

  double netSalary = 0.0;
  double tax = 0.0;
  double accountantFee = 189.0;
  double inss = 0.11;

  bool get hasValidInput => netSalary > 0 && tax > 0 && inss > 0;

  PjController() {
    _loadData();
  }

  void calculate() {
    final salary = salaryController.numberValue;
    final taxPercent =
        double.tryParse(taxController.text.replaceAll(',', '.')) ?? 0.0;
    final inssPercent =
        double.tryParse(inssController.text.replaceAll(',', '.')) ?? 0.0;

    accountantFee = accountantController.numberValue;
    tax = salary * (taxPercent / 100);
    inss = salary * (inssPercent / 100);

    final totalDiscount = tax + inss + accountantFee;
    netSalary = salary - totalDiscount;

    _saveData(salary, taxPercent, accountantFee, inssPercent);
    notifyListeners();
  }

  Future<void> _loadData() async {
    final model = await DatabaseService().loadPj();
    if (model != null) {
      salaryController.updateValue(model.salary);
      accountantController.updateValue(model.accountantFee);
      taxController.text = model.taxes.toStringAsFixed(0);
      inssController.text = model.inss.toStringAsFixed(0);
      calculate();
    }
  }

  Future<void> _saveData(
    double salary,
    double taxPercent,
    double accountant,
    double inssPercent,
  ) async {
    final model = PjModel(
      salary: salary,
      taxes: taxPercent,
      accountantFee: accountant,
      inss: inssPercent,
    );
    await DatabaseService().savePj(model);
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
