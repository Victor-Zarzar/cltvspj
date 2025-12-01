import 'dart:typed_data';
import 'package:cltvspj/models/report_model.dart';
import 'package:cltvspj/services/export_service.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/models/user_model.dart';
import 'package:cltvspj/services/database_service.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

class UserController extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final MoneyMaskedTextController salaryController = moneyMaskedController();
  final MoneyMaskedTextController benefitsController = moneyMaskedController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasLoadedOnce = false;
  bool get hasLoadedOnce => _hasLoadedOnce;

  bool get hasValidInput {
    return nameController.text.trim().isNotEmpty &&
        salaryController.text.trim().isNotEmpty &&
        benefitsController.text.trim().isNotEmpty &&
        professionController.text.trim().isNotEmpty;
  }

  bool get hasAnyValue {
    final hasName = nameController.text.trim().isNotEmpty;
    final hasProfession = professionController.text.trim().isNotEmpty;
    final hasSalary = salaryController.numberValue > 0;
    final hasBenefits = benefitsController.numberValue > 0;

    return hasName || hasProfession || hasSalary || hasBenefits;
  }

  void _resetMoneyControllers() {
    salaryController.updateValue(0);
    benefitsController.updateValue(0);
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _dbService.loadUser();
      if (user != null) {
        nameController.text = user.name;
        professionController.text = user.profession;
        salaryController.updateValue(user.salary);
        benefitsController.updateValue(user.benefits);
      } else {
        nameController.clear();
        professionController.clear();
        _resetMoneyControllers();
      }
      _hasLoadedOnce = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> exportToPdf({
    required String nome,
    Uint8List? chartBytes,
  }) async {
    String formatCurrency(double value) => currencyFormat.format(value);

    final double parsedSalary = salaryController.numberValue.toDouble();
    final double parsedBenefits = benefitsController.numberValue.toDouble();

    final reportData = ReportData(
      title: 'user_report_title'.tr(),
      name: nome,
      summaryRows: [
        ReportRow(label: 'name'.tr(), value: (nameController.text)),
        ReportRow(label: 'profession'.tr(), value: (professionController.text)),
        ReportRow(label: 'salary'.tr(), value: formatCurrency(parsedSalary)),
        ReportRow(
          label: 'benefits'.tr(),
          value: formatCurrency(parsedBenefits),
        ),
      ],
      benefits: {'benefits'.tr(): parsedBenefits},
      chartBytes: chartBytes,
      benefitsRows: [],
      labels: ReportLabels(
        namePrefix: 'report_name_prefix'.tr(),
        benefitsTitle: 'report_benefits_title'.tr(),
        chartTitle: 'report_chart_title'.tr(),
        tableHeaders: [
          'report_table_header_type'.tr(),
          'report_table_header_value'.tr(),
        ],
      ),
    );

    await generatePdfReport(reportData);
  }

  Future<void> saveUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = UserModel(
        name: nameController.text.trim(),
        salary: salaryController.numberValue.toDouble(),
        benefits: benefitsController.numberValue.toDouble(),
        profession: professionController.text.trim(),
      );

      await _dbService.saveUser(user);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _dbService.clearUser();
      nameController.clear();
      professionController.clear();
      _resetMoneyControllers();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    professionController.dispose();
    salaryController.dispose();
    benefitsController.dispose();
    super.dispose();
  }
}
