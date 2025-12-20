import 'dart:typed_data';
import 'package:cltvspj/services/export_service.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/models/user_model.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:cltvspj/controller/reports/user_report_builder.dart';
import 'package:cltvspj/controller/repositories/user_repository.dart';

class UserController extends ChangeNotifier {
  final UserRepository _repo;
  final UserReportBuilder _reportBuilder;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final MoneyMaskedTextController salaryController = moneyMaskedController();
  final MoneyMaskedTextController benefitsController = moneyMaskedController();

  String get userName => nameController.text.trim();
  String get professionName => professionController.text.trim();

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

  UserController({
    UserRepository? repo,
    UserReportBuilder reportBuilder = const UserReportBuilder(),
  }) : _repo = repo ?? UserRepository(),
       _reportBuilder = reportBuilder;

  void _resetMoneyControllers() {
    salaryController.updateValue(0);
    benefitsController.updateValue(0);
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _repo.load();
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
    required String name,
    required String profession,
    Uint8List? chartBytes,
  }) async {
    final double parsedSalary = salaryController.numberValue.toDouble();
    final double parsedBenefits = benefitsController.numberValue.toDouble();

    final reportData = _reportBuilder.build(
      name: name,
      profession: profession,
      salary: parsedSalary,
      benefits: parsedBenefits,
      chartBytes: chartBytes,
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

      await _repo.save(user);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repo.clear();
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
