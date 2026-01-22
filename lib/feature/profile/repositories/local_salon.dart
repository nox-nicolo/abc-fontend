import 'package:africa_beuty/feature/profile/model/salon.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SalonProfileStorage {
  static const _boxName = 'salon_profile_box';
  static const _key = 'salon_profile';

  static Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  /// Save salon profile to local cache
  static Future<void> save(SalonProfileModel salon) async {
    final box = await _openBox();
    // We store the result of toMap() so Hive handles it as a standard Map
    await box.put(_key, salon.toMap());
  }

  /// Load salon profile from local cache
  static Future<SalonProfileModel?> load() async {
    try {
      final box = await _openBox();
      final raw = box.get(_key);

      if (raw == null) return null;

      // Cast the Hive dynamic Map to a typed Map for the factory
      return SalonProfileModel.fromMap(
        Map<String, dynamic>.from(raw as Map),
      );
    } catch (e) {
      print('Hive Load Error: $e'); 
      await clear();
      return null;
    }
  }

  static Future<void> clear() async {
    final box = await _openBox();
    await box.delete(_key);
  }
}