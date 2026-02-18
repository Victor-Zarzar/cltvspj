class PjEntity {
  final double grossSalary;
  final double accountantFee;
  final double benefits;
  final double inss;
  final double taxes;

  PjEntity({
    required this.grossSalary,
    required this.accountantFee,
    required this.benefits,
    this.inss = 0.11,
    this.taxes = 0.6,
  });
}
