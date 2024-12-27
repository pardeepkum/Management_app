import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../Database/hive_db.dart';

final preferencesProvider = StateNotifierProvider<PreferencesNotifier, Preferences>(
      (ref) => PreferencesNotifier(),
);

class Preferences {
  final bool isDarkMode;
  final String sortOrder;

  Preferences({required this.isDarkMode, required this.sortOrder});
}

class PreferencesNotifier extends StateNotifier<Preferences> {
  PreferencesNotifier()
      : super(Preferences(isDarkMode: false, sortOrder: 'date'));

  void loadPreferences() {
    final isDarkMode = PreferencesService.isDarkMode;
    final sortOrder = PreferencesService.sortOrder;
    state = Preferences(isDarkMode: isDarkMode, sortOrder: sortOrder);
  }

  void toggleTheme() {
    final newState = !state.isDarkMode;
    PreferencesService.setDarkMode(newState);
    state = Preferences(isDarkMode: newState, sortOrder: state.sortOrder);
  }

  void changeSortOrder(String order) {
    PreferencesService.setSortOrder(order);
    state = Preferences(isDarkMode: state.isDarkMode, sortOrder: order);
  }
}
