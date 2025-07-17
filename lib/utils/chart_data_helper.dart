class ChartDataHelper {
  static Map<String, double> buildResultChartData({
    required double cltNet,
    required double pjNet,
  }) {
    return {'CLT': cltNet, 'PJ': pjNet};
  }
}
