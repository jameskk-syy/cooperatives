import 'package:cooperativeapp/model/offline_product.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class OfflineDatabaseHelper {
  static final OfflineDatabaseHelper _instance = OfflineDatabaseHelper._internal();
  factory OfflineDatabaseHelper() => _instance;
  OfflineDatabaseHelper._internal();

  Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'offline_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE offline_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            customerCode TEXT,
            unitOfMeasure TEXT,
            quantity INTEGER
          )
        ''');
      },
    );
  }

  Future<void> insertOfflineProduct(OfflineProduct product) async {
    final dbClient = await db;
    await dbClient.insert('offline_products', product.toMap());
  }
  Future<List<OfflineProduct>> getAllOfflineProducts() async {
  final dbClient = await db;
  final List<Map<String, dynamic>> maps = await dbClient.query('offline_products');

  return List.generate(maps.length, (i) {
    return OfflineProduct(
      customerCode: maps[i]['customerCode'],
      unitOfMeasure: maps[i]['unitOfMeasure'],
      quantity: maps[i]['quantity'],
    );
  });
}
Future<void> clearOfflineData() async {
  final dbClient = await db;
  await dbClient.delete('offline_products');
}

}
