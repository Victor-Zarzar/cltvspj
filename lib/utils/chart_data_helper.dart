import 'package:easy_localization/easy_localization.dart';

class ChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double cltNet,
    required double pjNet,
    required double difference,
  }) {
    return {'CLT': cltNet, 'PJ': pjNet, 'difference'.tr(): difference};
  }
}
