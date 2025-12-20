import 'package:cltvspj/models/user_model.dart';
import 'package:cltvspj/services/database_service.dart';

class UserRepository {
  final DatabaseService _db;

  UserRepository({DatabaseService? db}) : _db = db ?? DatabaseService();

  Future<UserModel?> load() => _db.loadUser();
  Future<void> save(UserModel user) => _db.saveUser(user);
  Future<void> clear() => _db.clearUser();
}
