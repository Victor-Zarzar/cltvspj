import 'package:cltvspj/features/user/domain/entities/user_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  static const _kName = 'user_profile.name';
  static const _kProfession = 'user_profile.profession';
  static const _kSalary = 'user_profile.salary';
  static const _kBenefits = 'user_profile.benefits';

  Future<UserEntity?> load() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString(_kName);
    final profession = prefs.getString(_kProfession);
    final salary = prefs.getDouble(_kSalary);
    final benefits = prefs.getDouble(_kBenefits);

    final hasAny =
        (name != null && name.trim().isNotEmpty) ||
        (profession != null && profession.trim().isNotEmpty) ||
        (salary != null && salary > 0) ||
        (benefits != null && benefits > 0);

    if (!hasAny) return null;

    return UserEntity(
      name: name ?? '',
      profession: profession ?? '',
      salary: (salary ?? 0).toDouble(),
      benefits: (benefits ?? 0).toDouble(),
    );
  }

  Future<void> save(UserEntity user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kName, user.name);
    await prefs.setString(_kProfession, user.profession);
    await prefs.setDouble(_kSalary, user.salary);
    await prefs.setDouble(_kBenefits, user.benefits);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kName);
    await prefs.remove(_kProfession);
    await prefs.remove(_kSalary);
    await prefs.remove(_kBenefits);
  }
}
