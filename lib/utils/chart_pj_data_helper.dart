import 'package:easy_localization/easy_localization.dart';

class PjChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double tax,
    required double accountantFee,
    required double inss,
    required double netSalary,
  }) {
    return {
      'taxes'.tr(): tax,
      'accountant'.tr(): accountantFee,
      'inss'.tr(): inss,
      'net'.tr(): netSalary,
    };
  }
}
