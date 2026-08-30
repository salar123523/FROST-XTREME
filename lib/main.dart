import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/device_data.dart';
import 'providers/device_provider.dart';
import 'providers/settings_provider.dart';
import 'utils/theme.dart';
import 'utils/constants.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/alarms/alarms_screen.dart';
import 'screens/reports/reports_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  // Requires the generated adapter from `flutter pub run build_runner build`
  // (device_data.dart declares `part 'device_data.g.dart'`).
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(DeviceDataAdapter());
  }
  await Hive.openBox<DeviceData>(AppConstants.hiveDeviceDataBox);

  final prefs = await SharedPreferences.getInstance();

  runApp(FrostXtremeApp(prefs: prefs));
}

class FrostXtremeApp extends StatelessWidget {
  final SharedPreferences prefs;

  const FrostXtremeApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DeviceProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider(prefs)),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const RootNavigation(),
      ),
    );
  }
}

class RootNavigation extends StatefulWidget {
  const RootNavigation({super.key});

  @override
  State<RootNavigation> createState() => _RootNavigationState();
}

class _RootNavigationState extends State<RootNavigation> {
  int _currentIndex = 0;

  static const _screens = [
    DashboardScreen(),
    AlarmsScreen(),
    ReportsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) =>
            setState(() => _currentIndex = index),
        backgroundColor: AppTheme.surfaceColor,
        indicatorColor: AppTheme.primaryColor.withOpacity(0.2),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard, color: AppTheme.primaryColor),
            label: 'داشبورد',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: deviceProvider.alarms.isNotEmpty,
              label: Text('${deviceProvider.alarms.length}'),
              child: const Icon(Icons.warning_amber_outlined),
            ),
            selectedIcon: const Icon(Icons.warning, color: AppTheme.dangerColor),
            label: 'هشدارها',
          ),
          const NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description, color: AppTheme.primaryColor),
            label: 'گزارشات',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppTheme.primaryColor),
            label: 'تنظیمات',
          ),
        ],
      ),
    );
  }
}
