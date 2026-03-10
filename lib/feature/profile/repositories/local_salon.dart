import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SalonProfileStorage {
  static const _boxName = 'salon_profile_box';
  static const _key = 'salon_profile';

  /// Optimized: Checks if the box is already open before trying to open it again.
  static Future<Box> _openBox() async {
    if (Hive.isBoxOpen(_boxName)) {
      return Hive.box(_boxName);
    }
    return await Hive.openBox(_boxName);
  }

  /// Save salon profile to local cache
  static Future<void> save(SalonProfileModel salon) async {
    try {
      final box = await _openBox();
      // We store the result of toMap() so Hive handles it as a standard Map
      await box.put(_key, salon.toMap());
    } catch (e) {
      print('Hive Save Error: $e');
    }
  }

  /// Load salon profile from local cache
  static Future<SalonProfileModel?> load() async {
    try {
      final box = await _openBox();
      final raw = box.get(_key);

      if (raw == null) return null;

      // Cast the Hive dynamic Map to a typed Map for the factory.
      // We use 'as Map' first because Hive returns a _Map<dynamic, dynamic>
      return SalonProfileModel.fromMap(
        Map<String, dynamic>.from(raw as Map),
      );
    } catch (e) {
      print('Hive Load Error: $e'); 
      // If data is corrupted or schema changed, clear it to prevent infinite crashes
      await clear();
      return null;
    }
  }

  /// Remove the cached profile (e.g., on Logout)
  static Future<void> clear() async {
    try {
      final box = await _openBox();
      await box.delete(_key);
    } catch (e) {
      print('Hive Clear Error: $e');
    }
  }
}