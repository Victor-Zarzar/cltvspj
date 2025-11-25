import 'dart:typed_data';

class ReportRow {
  final String label;
  final String value;

  const ReportRow({required this.label, required this.value});
}

class ReportLabels {
  final String namePrefix;
  final String benefitsTitle;
  final String chartTitle;
  final List<String> tableHeaders;

  const ReportLabels({
    required this.namePrefix,
    required this.benefitsTitle,
    required this.chartTitle,
    required this.tableHeaders,
  });
}

class ReportData {
  final String title;
  final String name;
  final List<ReportRow> summaryRows;
  final List<ReportRow> benefitsRows;
  final Uint8List? chartBytes;
  final ReportLabels labels;
  final Map<String, double> benefits;

  const ReportData({
    required this.title,
    required this.name,
    required this.summaryRows,
    required this.benefitsRows,
    required this.labels,
    required this.benefits,
    this.chartBytes,
  });
}
