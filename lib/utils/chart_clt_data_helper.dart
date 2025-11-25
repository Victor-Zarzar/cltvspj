import 'package:easy_localization/easy_localization.dart';

class CltChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double inss,
    required double irrf,
    required double benefits,
    required double netSalary,
  }) {
    return {
      'inss'.tr(): inss,
      'irrf'.tr(): irrf,
      'benefits'.tr(): benefits,
      'net_salary'.tr(): netSalary,
    };
  }
}
