import 'package:cltvspj/utils/salary_helper.dart';

class CltCalculationResult {
  final double grossSalary;
  final double benefits;
  final double inss;
  final double irrf;
  final double fgts;
  final double netSalaryWithoutBenefits;
  final double netSalary;

  const CltCalculationResult({
    required this.grossSalary,
    required this.benefits,
    required this.inss,
    required this.irrf,
    required this.fgts,
    required this.netSalaryWithoutBenefits,
    required this.netSalary,
  });
}

class CltCalculator {
  const CltCalculator();

  CltCalculationResult calculate({
    required double grossSalary,
    required double benefits,
  }) {
    final inss = calculateInss(grossSalary);
    final irrf = calculateIrrf(grossSalary);
    final fgts = calculateFgts(grossSalary);

    final netSalaryWithoutBenefits = grossSalary - inss - irrf;
    final netSalary = netSalaryWithoutBenefits + benefits;

    return CltCalculationResult(
      grossSalary: grossSalary,
      benefits: benefits,
      inss: inss,
      irrf: irrf,
      fgts: fgts,
      netSalaryWithoutBenefits: netSalaryWithoutBenefits,
      netSalary: netSalary,
    );
  }
}
