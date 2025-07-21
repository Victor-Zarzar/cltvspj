import 'package:shared_preferences/shared_preferences.dart';
import 'package:cltvspj/model/calculate_model.dart';
import 'package:cltvspj/model/clt_model.dart';

class StorageService {
  // ===== CLT =====

  static Future<void> saveCltData(CltModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('clt_salary', model.salaryClt);
    await prefs.setDouble('clt_benefits', model.benefits);
  }

  static Future<CltModel> loadCltData() async {
    final prefs = await SharedPreferences.getInstance();
    return CltModel(
      salaryClt: prefs.getDouble('clt_salary') ?? 0.0,
      benefits: prefs.getDouble('clt_benefits') ?? 0.0,
    );
  }

  // ===== Calculator =====

  static Future<void> saveCalculatorData(CalculatorModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('calc_salaryClt', model.salaryClt);
    await prefs.setDouble('calc_salaryPj', model.salaryPj);
    await prefs.setDouble('calc_benefits', model.benefits);
    await prefs.setDouble('calc_taxesPj', model.taxesPj);
    await prefs.setDouble('calc_accountantFee', model.accountantFee);
    await prefs.setDouble('calc_inssPj', model.inssPj);
  }

  static Future<CalculatorModel> loadCalculatorData() async {
    final prefs = await SharedPreferences.getInstance();
    return CalculatorModel(
      salaryClt: prefs.getDouble('calc_salaryClt') ?? 0.0,
      salaryPj: prefs.getDouble('calc_salaryPj') ?? 0.0,
      benefits: prefs.getDouble('calc_benefits') ?? 0.0,
      taxesPj: prefs.getDouble('calc_taxesPj') ?? 0.0,
      accountantFee: prefs.getDouble('calc_accountantFee') ?? 189.0,
      inssPj: prefs.getDouble('calc_inssPj') ?? 0.11,
    );
  }
}
