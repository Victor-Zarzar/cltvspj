import 'package:easy_localization/easy_localization.dart';

class ChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double cltNet,
    required double pjNet,
    required double difference,
    required double benefits,
    required double inss,
    required double accountantFee,
    required double fgts,
    required bool includeFgts,
  }) {
    final data = <String, double>{
      'CLT': cltNet,
      'PJ': pjNet,
      'difference'.tr(): difference,
      'benefits'.tr(): benefits,
      'inss_pj_description'.tr(): inss,
      'taxes_pj__description'.tr(): accountantFee,
    };

    if (includeFgts && fgts > 0) {
      data['fgts'.tr()] = fgts;
    }

    return data;
  }
}
