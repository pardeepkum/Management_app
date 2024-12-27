import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:management_app/utils/notification.dart';
import 'package:management_app/view/home_screen.dart';
import '../model/prefrences_model.dart';



void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  NotificationServices().initNotification();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget  {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(preferencesProvider).isDarkMode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Management App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomeScreen(),
    );
  }
}
