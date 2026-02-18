import 'package:easy_localization/easy_localization.dart';

class PjChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double tax,
    required double accountantFee,
    required double benefits,
    required double inss,
    required double netSalary,
  }) {
    return {
      'taxes'.tr(): tax,
      'accountant'.tr(): accountantFee,
      'benefits_pj'.tr(): benefits,
      'inss'.tr(): inss,
      'net'.tr(): netSalary,
    };
  }
}
