import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:easy_localization/easy_localization.dart';
import '../model/calculate_model.dart';
import '../utils/salary_helper.dart';
import '../services/storage_service.dart';

class CalculatorController extends ChangeNotifier {
  final salaryCltController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final salaryPjController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final benefitsController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final accountantFeeController = MoneyMaskedTextController(
    leftSymbol: 'R\$ ',
    decimalSeparator: ',',
    thousandSeparator: '.',
  );

  final taxesPjController = TextEditingController();
  final inssPjController = TextEditingController();

  CalculatorModel model = CalculatorModel(
    salaryClt: 0,
    salaryPj: 0,
    benefits: 0,
    taxesPj: 0,
    accountantFee: 189.0,
    inssPj: 0.11,
  );

  double _parsePercentage(TextEditingController controller) {
    return double.tryParse(controller.text.replaceAll(',', '.')) ?? 0.0;
  }

  bool get hasValidInput =>
      salaryCltController.numberValue > 0 &&
      _parsePercentage(inssPjController) > 0 &&
      _parsePercentage(taxesPjController) > 0;

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

  void updateValues() {
    model = CalculatorModel(
      salaryClt: salaryCltController.numberValue,
      salaryPj: salaryPjController.numberValue,
      benefits: benefitsController.numberValue,
      accountantFee: accountantFeeController.numberValue,
      taxesPj: _parsePercentage(taxesPjController),
      inssPj: _parsePercentage(inssPjController) / 100,
    );

    StorageService.saveData(model);
    notifyListeners();
  }

  Future<void> loadData() async {
    model = await StorageService.loadData();
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

  void calculate() => updateValues();

  void disposeAll() {
    salaryCltController.dispose();
    salaryPjController.dispose();
    benefitsController.dispose();
    accountantFeeController.dispose();
    taxesPjController.dispose();
    inssPjController.dispose();
  }
}
