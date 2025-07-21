class PjModel {
  final double salary;
  final double accountantFee;
  final double inss;
  final double taxes;

  PjModel({
    required this.salary,
    required this.accountantFee,
    this.inss = 0.11,
    this.taxes = 0.6,
  });
}
