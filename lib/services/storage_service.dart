import 'package:cltvspj/model/calculate_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveData(CalculatorModel model) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('salaryClt', model.salaryClt);
    prefs.setDouble('salaryPj', model.salaryPj);
    prefs.setDouble('benefits', model.benefits);
    prefs.setDouble('taxesPj', model.taxesPj);
    prefs.setDouble('accountantFee', model.accountantFee);
    prefs.setDouble('inssPj', model.inssPj);
  }

  static Future<CalculatorModel> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    return CalculatorModel(
      salaryClt: prefs.getDouble('salaryClt') ?? 0,
      salaryPj: prefs.getDouble('salaryPj') ?? 0,
      benefits: prefs.getDouble('benefits') ?? 0,
      taxesPj: prefs.getDouble('taxesPj') ?? 0,
      accountantFee: prefs.getDouble('accountantFee') ?? 189.0,
      inssPj: prefs.getDouble('inssPj') ?? 0.11,
    );
  }
}
