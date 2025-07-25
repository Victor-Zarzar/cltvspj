import 'package:easy_localization/easy_localization.dart';

class ChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double cltNet,
    required double pjNet,
    required double difference,
    required double benefits,
    required double inss,
    required double accountantFee,
  }) {
    return {
      'CLT': cltNet,
      'PJ': pjNet,
      'difference'.tr(): difference,
      'benefits'.tr(): benefits,
      'inss'.tr(): inss,
      'accountant'.tr(): accountantFee,
    };
  }
}
