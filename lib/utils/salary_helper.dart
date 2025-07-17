double calculateInss(double grossSalary) {
  if (grossSalary <= 1518.00) {
    return grossSalary * 0.075;
  } else if (grossSalary <= 2793.88) {
    return (1518.00 * 0.075) + ((grossSalary - 1518.00) * 0.09);
  } else if (grossSalary <= 4190.83) {
    return (1518.00 * 0.075) +
        ((2793.88 - 1518.00) * 0.09) +
        ((grossSalary - 2793.88) * 0.12);
  } else if (grossSalary <= 8157.41) {
    return (1518.00 * 0.075) +
        ((2793.88 - 1518.00) * 0.09) +
        ((4190.83 - 2793.88) * 0.12) +
        ((grossSalary - 4190.83) * 0.14);
  } else {
    return 1236.70;
  }
}

double calculateIrrf(double grossSalary) {
  final inss = calculateInss(grossSalary);
  final base = grossSalary - inss;

  if (base <= 3036.00) {
    return 0.0;
  } else if (base <= 4214.12) {
    return (base * 0.075) - 227.70;
  } else if (base <= 5282.45) {
    return (base * 0.15) - 556.02;
  } else if (base <= 6765.66) {
    return (base * 0.225) - 922.57;
  } else {
    return (base * 0.275) - 1265.98;
  }
}
