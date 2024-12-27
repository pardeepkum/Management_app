import 'package:hive/hive.dart';

class PreferencesService {
  static late Box _box;

  static Future<void> init() async {
    _box = await Hive.openBox('preferences');
  }

  static bool get isDarkMode => _box.get('isDarkMode', defaultValue: false);
  static String get sortOrder => _box.get('sortOrder', defaultValue: 'date');

  static Future<void> setDarkMode(bool value) async {
    await _box.put('isDarkMode', value);
  }

  static Future<void> setSortOrder(String value) async {
    await _box.put('sortOrder', value);
  }
}
