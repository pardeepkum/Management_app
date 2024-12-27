import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final preferencesProvider =
StateNotifierProvider<PreferencesNotifier, PreferencesState>(
        (ref) => PreferencesNotifier());

class PreferencesState {
  final bool isDarkMode;

  PreferencesState({required this.isDarkMode});

  PreferencesState toggleTheme() => PreferencesState(isDarkMode: !isDarkMode);

  Map<String, dynamic> toMap() => {'isDarkMode': isDarkMode};
  factory PreferencesState.fromMap(Map<String, dynamic> map) =>
      PreferencesState(isDarkMode: map['isDarkMode'] ?? false);
}

class PreferencesNotifier extends StateNotifier<PreferencesState> {
  PreferencesNotifier() : super(PreferencesState(isDarkMode: false)) {
    _loadPreferences();
  }

  void toggleTheme() {
    state = state.toggleTheme();
    _savePreferences();
  }

  void _savePreferences() async {
    var box = await Hive.openBox('preferences');
    await box.put('preferences', state.toMap());
  }

  void _loadPreferences() async {
    var box = await Hive.openBox('preferences');
    final map = box.get('preferences', defaultValue: {'isDarkMode': false});
    state = PreferencesState.fromMap(Map<String, dynamic>.from(map));
  }
}
