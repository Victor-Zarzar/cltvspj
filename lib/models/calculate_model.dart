class CalculatorModel {
  final double salaryClt;
  final double salaryPj;
  final double benefits;
  final double taxesPj;
  final double accountantFee;
  final double inssPj;

  CalculatorModel({
    required this.salaryClt,
    required this.salaryPj,
    required this.benefits,
    required this.taxesPj,
    this.accountantFee = 189.0,
    this.inssPj = 0.11,
  });
}
