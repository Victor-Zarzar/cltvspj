import 'package:easy_localization/easy_localization.dart';

class CltChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double netSalary,
    required double inss,
    required double irrf,
    required double benefits,
  }) {
    return {
      'inss'.tr(): inss,
      'irrf'.tr(): irrf,
      'benefits'.tr(): benefits,
      'net'.tr(): netSalary,
    };
  }
}
