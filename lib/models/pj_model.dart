class PjModel {
  final double grossSalary;
  final double accountantFee;
  final double benefits;
  final double inss;
  final double taxes;

  PjModel({
    required this.grossSalary,
    required this.accountantFee,
    required this.benefits,
    this.inss = 0.11,
    this.taxes = 0.6,
  });
}
