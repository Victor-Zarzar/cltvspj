import 'dart:async';
import 'package:cltvspj/models/calculate_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:cltvspj/models/clt_model.dart';
import 'package:cltvspj/models/pj_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _db;

  DatabaseService._internal();

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "app_data.db");

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE calculator (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        salaryClt REAL,
        salaryPj REAL,
        benefits REAL,
        taxesPj REAL,
        accountantFee REAL,
        inssPj REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE clt (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        salaryClt REAL,
        benefits REAL
      );
    ''');

    await db.execute('''
      CREATE TABLE pj (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        grosssalary REAL,
        accountantFee REAL,
        inss REAL,
        taxes REAL
      );
    ''');
  }

  Future<void> saveClt(CltModel model) async {
    final dbClient = await db;
    await dbClient.delete('clt');
    await dbClient.insert('clt', {
      'salaryClt': model.salaryClt,
      'benefits': model.benefits,
    });
  }

  Future<CltModel?> loadClt() async {
    final dbClient = await db;
    final result = await dbClient.query('clt', limit: 1);
    if (result.isEmpty) return null;
    final row = result.first;
    return CltModel(
      salaryClt: row['salaryClt'] as double,
      benefits: row['benefits'] as double,
    );
  }

  Future<void> savePj(PjModel model) async {
    final dbClient = await db;
    await dbClient.delete('pj');
    await dbClient.insert('pj', {
      'grosssalary': model.grossSalary,
      'accountantFee': model.accountantFee,
      'inss': model.inss,
      'taxes': model.taxes,
    });
  }

  Future<PjModel?> loadPj() async {
    final dbClient = await db;
    final result = await dbClient.query('pj', limit: 1);
    if (result.isEmpty) return null;
    final row = result.first;
    return PjModel(
      grossSalary: row['grosssalary'] as double,
      accountantFee: row['accountantFee'] as double,
      inss: row['inss'] as double,
      taxes: row['taxes'] as double,
    );
  }

  Future<void> saveCalculator(CalculatorModel model) async {
    final dbClient = await db;
    await dbClient.delete('calculator');
    await dbClient.insert('calculator', {
      'salaryClt': model.salaryClt,
      'salaryPj': model.salaryPj,
      'benefits': model.benefits,
      'taxesPj': model.taxesPj,
      'accountantFee': model.accountantFee,
      'inssPj': model.inssPj,
    });
  }

  Future<CalculatorModel?> loadCalculator() async {
    final dbClient = await db;
    final result = await dbClient.query('calculator', limit: 1);
    if (result.isEmpty) return null;
    final row = result.first;
    return CalculatorModel(
      salaryClt: row['salaryClt'] as double,
      salaryPj: row['salaryPj'] as double,
      benefits: row['benefits'] as double,
      taxesPj: row['taxesPj'] as double,
      accountantFee: row['accountantFee'] as double,
      inssPj: row['inssPj'] as double,
    );
  }
}
