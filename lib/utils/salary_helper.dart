double calculateInss(double grossSalary) {
  if (grossSalary <= 1621.00) {
    return grossSalary * 0.075;
  } else if (grossSalary <= 3061.00) {
    return (1621.00 * 0.075) + ((grossSalary - 1621.00) * 0.09);
  } else if (grossSalary <= 6101.06) {
    return (1621.00 * 0.075) +
        ((3061.00 - 1621.00) * 0.09) +
        ((grossSalary - 3061.00) * 0.12);
  } else if (grossSalary <= 8475.55) {
    return (1621.00 * 0.075) +
        ((3061.00 - 1621.00) * 0.09) +
        ((6101.06 - 3061.00) * 0.12) +
        ((grossSalary - 6101.06) * 0.14);
  } else {
    return (1621.00 * 0.075) +
        ((3061.00 - 1621.00) * 0.09) +
        ((6101.06 - 3061.00) * 0.12) +
        ((8475.55 - 6101.06) * 0.14);
  }
}

double calculateIrrf(double grossSalary) {
  final inssDeduction = calculateInss(grossSalary);
  const simplifiedDiscount = 607.20;
  final taxBase =
      grossSalary -
      (inssDeduction > simplifiedDiscount ? inssDeduction : simplifiedDiscount);

  double irrf = 0.0;

  if (taxBase <= 2428.80) {
    irrf = 0.0;
  } else if (taxBase <= 3227.73) {
    irrf = (taxBase * 0.075) - 182.16;
  } else if (taxBase <= 4087.87) {
    irrf = (taxBase * 0.15) - 394.16;
  } else if (taxBase <= 5052.87) {
    irrf = (taxBase * 0.225) - 675.49;
  } else {
    irrf = (taxBase * 0.275) - 908.73;
  }

  if (grossSalary <= 7350.00 && irrf > 0) {
    const maxReduction = 312.89;
    final reduction = irrf < maxReduction ? irrf : maxReduction;
    irrf = irrf - reduction;
  }

  return irrf < 0 ? 0.0 : irrf;
}

double calculateFgts(double grossSalary) {
  return grossSalary * 0.08;
}
