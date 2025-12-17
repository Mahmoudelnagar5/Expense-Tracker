import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:expense_tracker_ar/core/helper/database/sqlite_helper.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper.dart';
import 'package:expense_tracker_ar/core/helper/database/cache_helper_keks.dart';

class BackupRestoreService {
  static const String _backupFileName = 'expense_tracker_backup.json';

  /// Create a backup of all user data
  Future<bool> createBackup() async {
    try {
      // Get all transactions from database
      final transactions = await SQLiteHelper().getAllTransactions();

      // Get all user preferences from cache
      final cacheHelper = CacheHelper();
      final preferences = <String, dynamic>{};

      // Get all preference keys
      final keys = [
        CacheHelperKeys.imageProfile,
        CacheHelperKeys.username,
        CacheHelperKeys.currency,
        CacheHelperKeys.language,
        CacheHelperKeys.isSetupComplete,
        CacheHelperKeys.theme,
        CacheHelperKeys.reminderEnabled,
        CacheHelperKeys.reminderHour,
        CacheHelperKeys.reminderMinute,
        CacheHelperKeys.appLockEnabled,
        CacheHelperKeys.appLockPin,
      ];

      for (var key in keys) {
        final value = cacheHelper.getData(key: key);
        if (value != null) {
          // Special handling for image profile - encode as Base64
          if (key == CacheHelperKeys.imageProfile && value is String) {
            final imageFile = File(value);
            if (await imageFile.exists()) {
              final imageBytes = await imageFile.readAsBytes();
              final base64Image = base64Encode(imageBytes);
              preferences['${key}_base64'] = base64Image;
              // Also save the file extension for proper restoration
              final extension = value.split('.').last;
              preferences['${key}_extension'] = extension;
            }
          } else {
            preferences[key] = value;
          }
        }
      }

      // Create backup data structure
      final backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'transactions': transactions.map((t) => t.toMap()).toList(),
        'preferences': preferences,
      };

      // Convert to JSON
      final jsonString = jsonEncode(backupData);

      // Get temporary directory to save backup file
      final tempDir = await getTemporaryDirectory();
      final backupFile = File('${tempDir.path}/$_backupFileName');
      await backupFile.writeAsString(jsonString);

      // Share the backup file
      final xFile = XFile(backupFile.path);
      final shareResult = await Share.shareXFiles(
        [xFile],
        text:
            'Expense Tracker Backup - ${DateTime.now().toString().split('.')[0]}',
        subject: 'Expense Tracker Data Backup',
      );

      // Return true only if the user actually saved/shared the file
      return shareResult.status == ShareResultStatus.success;
    } catch (e) {
      print('Backup failed: $e');
      return false;
    }
  }

  /// Restore data from backup file
  Future<bool> restoreFromBackup() async {
    try {
      // Pick backup file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Select Backup File',
      );

      if (result == null || result.files.isEmpty) {
        return false;
      }

      final filePath = result.files.first.path;
      if (filePath == null) return false;

      // Read backup file
      final backupFile = File(filePath);
      final jsonString = await backupFile.readAsString();

      // Parse JSON
      final backupData = jsonDecode(jsonString) as Map<String, dynamic>;

      // Validate backup format
      if (!backupData.containsKey('transactions') ||
          !backupData.containsKey('preferences')) {
        throw Exception('Invalid backup file format');
      }

      // Clear existing data
      await _clearAllData();

      // Restore transactions
      final transactionsData = backupData['transactions'] as List<dynamic>;
      final sqliteHelper = SQLiteHelper();

      for (var transactionMap in transactionsData) {
        // Convert map back to transaction model and insert
        final transaction = transactionMap as Map<String, dynamic>;

        // Insert using raw SQL to avoid model conversion issues
        await sqliteHelper.database.then((db) async {
          await db.insert('transactions', transaction);
        });
      }

      // Restore preferences
      final preferences = backupData['preferences'] as Map<String, dynamic>;
      final cacheHelper = CacheHelper();

      // Handle profile image restoration separately
      if (preferences.containsKey('${CacheHelperKeys.imageProfile}_base64')) {
        final base64Image =
            preferences['${CacheHelperKeys.imageProfile}_base64'] as String;
        final extension =
            preferences['${CacheHelperKeys.imageProfile}_extension'] as String?;
        final fileExtension = extension ?? 'jpg';

        // Decode and save image to app documents directory
        final imageBytes = base64Decode(base64Image);
        final appDir = await getApplicationDocumentsDirectory();
        final imagePath =
            '${appDir.path}/profile_image_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(imageBytes);

        // Save the new image path to cache
        await cacheHelper.saveData(
          key: CacheHelperKeys.imageProfile,
          value: imagePath,
        );
      }

      // Restore other preferences (skip the Base64 image data keys)
      for (var entry in preferences.entries) {
        // Skip the special image keys - already handled above
        if (entry.key.contains('_base64') || entry.key.contains('_extension')) {
          continue;
        }
        await cacheHelper.saveData(key: entry.key, value: entry.value);
      }

      return true;
    } catch (e) {
      print('Restore failed: $e');
      return false;
    }
  }

  /// Clear all user data (used before restore)
  Future<void> _clearAllData() async {
    try {
      // Clear database
      await SQLiteHelper().deleteDatabase();

      // Clear cache (keep only essential app settings)
      final cacheHelper = CacheHelper();
      final keys = [
        CacheHelperKeys.imageProfile,
        CacheHelperKeys.username,
        CacheHelperKeys.currency,
        CacheHelperKeys.language,
        CacheHelperKeys.isSetupComplete,
        CacheHelperKeys.theme,
        CacheHelperKeys.reminderEnabled,
        CacheHelperKeys.reminderHour,
        CacheHelperKeys.reminderMinute,
        CacheHelperKeys.appLockEnabled,
        CacheHelperKeys.appLockPin,
      ];

      // Don't clear these essential settings during restore
      final preserveKeys = [
        CacheHelperKeys.isSetupComplete,
        CacheHelperKeys.language,
      ];

      for (var key in keys) {
        if (!preserveKeys.contains(key)) {
          await cacheHelper.removeData(key: key);
        }
      }
    } catch (e) {
      print('Clear data failed: $e');
      rethrow;
    }
  }

  /// Get backup file information for display
  Future<Map<String, dynamic>?> getBackupInfo(String filePath) async {
    try {
      final file = File(filePath);
      final jsonString = await file.readAsString();
      final data = jsonDecode(jsonString) as Map<String, dynamic>;

      final transactionCount = (data['transactions'] as List).length;
      final timestamp = DateTime.parse(data['timestamp'] as String);

      return {
        'transactionCount': transactionCount,
        'timestamp': timestamp,
        'fileSize': await file.length(),
      };
    } catch (e) {
      return null;
    }
  }
}
