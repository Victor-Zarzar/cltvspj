class PjCalculationInput {
  final double grossSalary;
  final double taxPercent;
  final double benefitsValue;
  final double inssPercent;
  final double accountantFee;

  const PjCalculationInput({
    required this.grossSalary,
    required this.taxPercent,
    required this.benefitsValue,
    required this.inssPercent,
    required this.accountantFee,
  });
}

class PjCalculationResult {
  final double grossSalary;
  final double taxPercent;
  final double inssPercent;

  final double benefitsValue;
  final double taxValue;
  final double inssValue;
  final double accountantFee;
  final double totalDiscount;
  final double netSalary;

  const PjCalculationResult({
    required this.grossSalary,
    required this.taxPercent,

    required this.inssPercent,
    required this.benefitsValue,
    required this.taxValue,
    required this.inssValue,
    required this.accountantFee,
    required this.totalDiscount,
    required this.netSalary,
  });
}

class PjCalculator {
  const PjCalculator();

  PjCalculationResult calculate(PjCalculationInput input) {
    final taxValue = input.grossSalary * (input.taxPercent / 100);
    final inssValue = input.grossSalary * (input.inssPercent / 100);
    final benefitsValue = input.benefitsValue;
    final totalDiscount = taxValue + inssValue + input.accountantFee;
    final netSalary = (input.grossSalary - totalDiscount) + benefitsValue;

    return PjCalculationResult(
      grossSalary: input.grossSalary,
      taxPercent: input.taxPercent,
      inssPercent: input.inssPercent,
      taxValue: taxValue,
      benefitsValue: input.benefitsValue,
      inssValue: inssValue,
      accountantFee: input.accountantFee,
      totalDiscount: totalDiscount,
      netSalary: netSalary,
    );
  }
}
