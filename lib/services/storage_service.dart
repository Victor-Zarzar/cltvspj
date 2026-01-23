import 'package:cltvspj/models/calculate_model.dart';
import 'package:cltvspj/models/clt_model.dart';
import 'package:cltvspj/models/pj_model.dart';
import 'package:cltvspj/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  static const _kUserName = 'user_profile.name';
  static const _kUserProfession = 'user_profile.profession';
  static const _kUserSalary = 'user_profile.salary';
  static const _kUserBenefits = 'user_profile.benefits';
  static const _kCltSalary = 'clt.salaryClt';
  static const _kCltBenefits = 'clt.benefits';
  static const _kPjGrossSalary = 'pj.grossSalary';
  static const _kPjAccountantFee = 'pj.accountantFee';
  static const _kPjInss = 'pj.inss';
  static const _kPjTaxes = 'pj.taxes';
  static const _kPjBenefits = 'pj.benefits';
  static const _kCalcSalaryClt = 'calculator.salaryClt';
  static const _kCalcSalaryPj = 'calculator.salaryPj';
  static const _kCalcBenefits = 'calculator.benefits';
  static const _kCalcTaxesPj = 'calculator.taxesPj';
  static const _kCalcAccountantFee = 'calculator.accountantFee';
  static const _kCalcInssPj = 'calculator.inssPj';

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  bool _hasAnyNumeric(Iterable<double?> values) =>
      values.any((v) => v != null && v != 0);

  Future<void> saveUser(UserModel user) async {
    final prefs = await _prefs;
    await prefs.setString(_kUserName, user.name);
    await prefs.setString(_kUserProfession, user.profession);
    await prefs.setDouble(_kUserSalary, user.salary);
    await prefs.setDouble(_kUserBenefits, user.benefits);
  }

  Future<UserModel?> loadUser() async {
    final prefs = await _prefs;

    final name = prefs.getString(_kUserName);
    final profession = prefs.getString(_kUserProfession);
    final salary = prefs.getDouble(_kUserSalary);
    final benefits = prefs.getDouble(_kUserBenefits);

    final hasAny =
        (name != null && name.trim().isNotEmpty) ||
        (profession != null && profession.trim().isNotEmpty) ||
        _hasAnyNumeric([salary, benefits]);

    if (!hasAny) return null;

    return UserModel(
      name: name ?? '',
      profession: profession ?? '',
      salary: (salary ?? 0).toDouble(),
      benefits: (benefits ?? 0).toDouble(),
    );
  }

  Future<void> clearUser() async {
    final prefs = await _prefs;
    await prefs.remove(_kUserName);
    await prefs.remove(_kUserProfession);
    await prefs.remove(_kUserSalary);
    await prefs.remove(_kUserBenefits);
  }

  Future<void> saveClt(CltModel model) async {
    final prefs = await _prefs;
    await prefs.setDouble(_kCltSalary, model.salaryClt);
    await prefs.setDouble(_kCltBenefits, model.benefits);
  }

  Future<CltModel?> loadClt() async {
    final prefs = await _prefs;
    final salary = prefs.getDouble(_kCltSalary);
    final benefits = prefs.getDouble(_kCltBenefits);

    final hasAny = _hasAnyNumeric([salary, benefits]);
    if (!hasAny) return null;

    return CltModel(
      salaryClt: (salary ?? 0).toDouble(),
      benefits: (benefits ?? 0).toDouble(),
    );
  }

  Future<void> clearClt() async {
    final prefs = await _prefs;
    await prefs.remove(_kCltSalary);
    await prefs.remove(_kCltBenefits);
  }

  Future<void> savePj(PjModel model) async {
    final prefs = await _prefs;
    await prefs.setDouble(_kPjGrossSalary, model.grossSalary);
    await prefs.setDouble(_kPjAccountantFee, model.accountantFee);
    await prefs.setDouble(_kPjBenefits, model.benefits);
    await prefs.setDouble(_kPjInss, model.inss);
    await prefs.setDouble(_kPjTaxes, model.taxes);
  }

  Future<PjModel?> loadPj() async {
    final prefs = await _prefs;
    final grossSalary = prefs.getDouble(_kPjGrossSalary);
    final accountantFee = prefs.getDouble(_kPjAccountantFee);
    final benefits = prefs.getDouble(_kPjBenefits);
    final inss = prefs.getDouble(_kPjInss);
    final taxes = prefs.getDouble(_kPjTaxes);

    final hasAny = _hasAnyNumeric([grossSalary, accountantFee, inss, taxes]);
    if (!hasAny) return null;

    return PjModel(
      grossSalary: (grossSalary ?? 0).toDouble(),
      accountantFee: (accountantFee ?? 0).toDouble(),
      benefits: (benefits ?? 0).toDouble(),
      inss: (inss ?? 0).toDouble(),
      taxes: (taxes ?? 0).toDouble(),
    );
  }

  Future<void> clearPj() async {
    final prefs = await _prefs;
    await prefs.remove(_kPjGrossSalary);
    await prefs.remove(_kPjAccountantFee);
    await prefs.remove(_kPjBenefits);
    await prefs.remove(_kPjInss);
    await prefs.remove(_kPjTaxes);
  }

  Future<void> saveCalculator(CalculatorModel model) async {
    final prefs = await _prefs;
    await prefs.setDouble(_kCalcSalaryClt, model.salaryClt);
    await prefs.setDouble(_kCalcSalaryPj, model.salaryPj);
    await prefs.setDouble(_kCalcBenefits, model.benefits);
    await prefs.setDouble(_kCalcTaxesPj, model.taxesPj);
    await prefs.setDouble(_kCalcAccountantFee, model.accountantFee);
    await prefs.setDouble(_kCalcInssPj, model.inssPj);
  }

  Future<CalculatorModel?> loadCalculator() async {
    final prefs = await _prefs;

    final salaryClt = prefs.getDouble(_kCalcSalaryClt);
    final salaryPj = prefs.getDouble(_kCalcSalaryPj);
    final benefits = prefs.getDouble(_kCalcBenefits);
    final taxesPj = prefs.getDouble(_kCalcTaxesPj);
    final accountantFee = prefs.getDouble(_kCalcAccountantFee);
    final inssPj = prefs.getDouble(_kCalcInssPj);

    final hasAny = _hasAnyNumeric([
      salaryClt,
      salaryPj,
      benefits,
      taxesPj,
      accountantFee,
      inssPj,
    ]);
    if (!hasAny) return null;

    return CalculatorModel(
      salaryClt: (salaryClt ?? 0).toDouble(),
      salaryPj: (salaryPj ?? 0).toDouble(),
      benefits: (benefits ?? 0).toDouble(),
      taxesPj: (taxesPj ?? 0).toDouble(),
      accountantFee: (accountantFee ?? 0).toDouble(),
      inssPj: (inssPj ?? 0).toDouble(),
    );
  }

  Future<void> clearCalculator() async {
    final prefs = await _prefs;
    await prefs.remove(_kCalcSalaryClt);
    await prefs.remove(_kCalcSalaryPj);
    await prefs.remove(_kCalcBenefits);
    await prefs.remove(_kCalcTaxesPj);
    await prefs.remove(_kCalcAccountantFee);
    await prefs.remove(_kCalcInssPj);
  }
}
