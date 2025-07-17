class CalculatorModel {
  double salaryClt;
  double salaryPj;
  double benefits;
  double taxesPj;
  double accountantFee;
  double inssPj;

  CalculatorModel({
    required this.salaryClt,
    required this.salaryPj,
    required this.benefits,
    required this.taxesPj,
    this.accountantFee = 189.0,
    this.inssPj = 0.11,
  });
}
