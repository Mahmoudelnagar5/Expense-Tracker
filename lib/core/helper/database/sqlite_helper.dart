import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:expense_tracker_ar/core/models/transaction_model.dart';

/// SQLite Database Helper for managing local storage of transactions
class SQLiteHelper {
  static final SQLiteHelper _instance = SQLiteHelper._internal();
  static Database? _database;

  factory SQLiteHelper() => _instance;

  SQLiteHelper._internal();

  /// Get database instance (singleton pattern)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense_tracker.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        categoryName TEXT NOT NULL,
        categoryType TEXT NOT NULL,
        dateTime TEXT NOT NULL,
        amount REAL NOT NULL,
        notes TEXT,
        paymentType TEXT NOT NULL DEFAULT 'Cash',
        attachmentImages TEXT
      )
    ''');

    // Create index for faster queries
    await db.execute('''
      CREATE INDEX idx_dateTime ON transactions(dateTime)
    ''');

    await db.execute('''
      CREATE INDEX idx_categoryType ON transactions(categoryType)
    ''');
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future database schema changes here
    if (oldVersion < 2) {
      // Add paymentType column in version 2
      await db.execute(
        'ALTER TABLE transactions ADD COLUMN paymentType TEXT NOT NULL DEFAULT "Cash"',
      );
    }
  }

  /// Insert a new transaction
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all transactions
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'dateTime DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  /// Get transaction by ID
  Future<TransactionModel?> getTransactionById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (maps.isEmpty) return null;
    return TransactionModel.fromMap(maps.first);
  }

  /// Get transactions by date range
  Future<List<TransactionModel>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'dateTime BETWEEN ? AND ?',
      whereArgs: [startDate.toIso8601String(), endDate.toIso8601String()],
      orderBy: 'dateTime DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  /// Get transactions by category type (income/expense)
  Future<List<TransactionModel>> getTransactionsByType(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'categoryType = ?',
      whereArgs: [type],
      orderBy: 'dateTime DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  /// Get transactions by category name
  Future<List<TransactionModel>> getTransactionsByCategory(
    String categoryName,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'categoryName = ?',
      whereArgs: [categoryName],
      orderBy: 'dateTime DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  /// Get transactions for a specific month
  Future<List<TransactionModel>> getTransactionsByMonth(
    int year,
    int month,
  ) async {
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);
    return await getTransactionsByDateRange(startDate, endDate);
  }

  /// Get total income for a date range
  Future<double> getTotalIncome(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total FROM transactions
      WHERE categoryType = 'income'
      AND dateTime BETWEEN ? AND ?
    ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  /// Get total expenses for a date range
  Future<double> getTotalExpenses(DateTime startDate, DateTime endDate) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT SUM(amount) as total FROM transactions
      WHERE categoryType = 'expense'
      AND dateTime BETWEEN ? AND ?
    ''',
      [startDate.toIso8601String(), endDate.toIso8601String()],
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }

  /// Get balance (income - expenses) for a date range
  Future<double> getBalance(DateTime startDate, DateTime endDate) async {
    final income = await getTotalIncome(startDate, endDate);
    final expenses = await getTotalExpenses(startDate, endDate);
    return income - expenses;
  }

  /// Get category-wise summary for a date range
  Future<Map<String, double>> getCategorySummary(
    DateTime startDate,
    DateTime endDate,
    String type,
  ) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT categoryName, SUM(amount) as total FROM transactions
      WHERE categoryType = ?
      AND dateTime BETWEEN ? AND ?
      GROUP BY categoryName
      ORDER BY total DESC
    ''',
      [type, startDate.toIso8601String(), endDate.toIso8601String()],
    );

    final Map<String, double> summary = {};
    for (var row in result) {
      summary[row['categoryName'] as String] = (row['total'] as num).toDouble();
    }
    return summary;
  }

  /// Update a transaction
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// Delete a transaction by ID
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  /// Delete all transactions (use with caution)
  Future<int> deleteAllTransactions() async {
    final db = await database;
    return await db.delete('transactions');
  }

  /// Get transaction count
  Future<int> getTransactionCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM transactions',
    );
    return (result.first['count'] as int?) ?? 0;
  }

  /// Search transactions by notes
  Future<List<TransactionModel>> searchTransactions(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      where: 'notes LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'dateTime DESC',
    );

    return List.generate(maps.length, (i) {
      return TransactionModel.fromMap(maps[i]);
    });
  }

  /// Close the database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete the database (for testing or reset)
  Future<void> deleteDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'expense_tracker.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
