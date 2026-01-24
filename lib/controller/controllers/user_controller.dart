import 'dart:typed_data';
import 'package:cltvspj/services/export_service.dart';
import 'package:flutter/material.dart';
import 'package:cltvspj/models/user_model.dart';
import 'package:cltvspj/utils/currency_format_helper.dart';
import 'package:cltvspj/controller/reports/user_report_builder.dart';
import 'package:cltvspj/controller/repositories/user_repository.dart';

class UserController extends ChangeNotifier {
  final UserRepository _repo;
  final UserReportBuilder _reportBuilder;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController benefitsController = TextEditingController();

  String get userName => nameController.text.trim();
  String get professionName => professionController.text.trim();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasLoadedOnce = false;
  bool get hasLoadedOnce => _hasLoadedOnce;

  bool get hasValidInput {
    return nameController.text.trim().isNotEmpty &&
        professionController.text.trim().isNotEmpty &&
        !isZeroOrEmptyCurrency(salaryController.text) &&
        !isZeroOrEmptyCurrency(benefitsController.text);
  }

  bool get hasAnyValue {
    final hasName = nameController.text.trim().isNotEmpty;
    final hasProfession = professionController.text.trim().isNotEmpty;
    final hasSalary = parseBrlToDouble(salaryController.text) > 0;
    final hasBenefits = parseBrlToDouble(benefitsController.text) > 0;

    return hasName || hasProfession || hasSalary || hasBenefits;
  }

  UserController({
    UserRepository? repo,
    UserReportBuilder reportBuilder = const UserReportBuilder(),
  }) : _repo = repo ?? UserRepository(),
       _reportBuilder = reportBuilder;

  void _resetMoneyFields() {
    salaryController.text = formatCurrency(0);
    benefitsController.text = formatCurrency(0);
  }

  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _repo.load();
      if (user != null) {
        nameController.text = user.name;
        professionController.text = user.profession;
        salaryController.text = formatCurrency(user.salary);
        benefitsController.text = formatCurrency(user.benefits);
      } else {
        nameController.clear();
        professionController.clear();
        _resetMoneyFields();
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
    final parsedSalary = parseBrlToDouble(salaryController.text);
    final parsedBenefits = parseBrlToDouble(benefitsController.text);

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
        salary: parseBrlToDouble(salaryController.text),
        benefits: parseBrlToDouble(benefitsController.text),
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
      _resetMoneyFields();
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
