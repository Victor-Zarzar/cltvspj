import 'package:cltvspj/core/utils/salary_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class CalculatorEngineResult {
  final double totalClt;
  final double totalPj;
  final double differenceAbs;
  final String bestOptionText;

  const CalculatorEngineResult({
    required this.totalClt,
    required this.totalPj,
    required this.differenceAbs,
    required this.bestOptionText,
  });
}

class CalculatorEngine {
  const CalculatorEngine();

  double totalClt({required double salaryClt, required double benefits}) {
    final inss = calculateInss(salaryClt);
    final irrf = calculateIrrf(salaryClt);
    return salaryClt - inss - irrf + benefits;
  }

  double totalPj({
    required double salaryPj,
    required double taxesPjPercent,
    required double inssPjRate,
    required double accountantFee,
  }) {
    final taxPj = salaryPj * (taxesPjPercent / 100);
    final inss = salaryPj * inssPjRate;
    return salaryPj - (taxPj + inss + accountantFee);
  }

  CalculatorEngineResult evaluate({
    required double salaryClt,
    required double benefits,
    required double salaryPj,
    required double taxesPjPercent,
    required double inssPjRate,
    required double accountantFee,
    required String amountFormatted,
  }) {
    final clt = totalClt(salaryClt: salaryClt, benefits: benefits);
    final pj = totalPj(
      salaryPj: salaryPj,
      taxesPjPercent: taxesPjPercent,
      inssPjRate: inssPjRate,
      accountantFee: accountantFee,
    );

    final diff = (clt - pj).abs();

    final String best;
    if (clt > pj) {
      best = 'clt_better'.tr(namedArgs: {'amount': amountFormatted});
    } else if (pj > clt) {
      best = 'pj_better'.tr(namedArgs: {'amount': amountFormatted});
    } else {
      best = 'perfect_tie'.tr();
    }

    return CalculatorEngineResult(
      totalClt: clt,
      totalPj: pj,
      differenceAbs: diff,
      bestOptionText: best,
    );
  }
}
