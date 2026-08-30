import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/device_provider.dart';
import '../../utils/theme.dart';
import 'alarm_item.dart';

class AlarmsScreen extends StatelessWidget {
  const AlarmsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'هشدارها',
          style: AppTheme.orbitronTextStyle(size: 18),
        ),
        actions: [
          if (deviceProvider.alarms.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: deviceProvider.clearAlarms,
              tooltip: 'پاک کردن همه',
            ),
        ],
      ),
      body: deviceProvider.alarms.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 80,
                    color: AppTheme.successColor.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'هیچ هشداری فعال نیست',
                    style: AppTheme.orbitronTextStyle(
                      size: 20,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                  Text(
                    'سیستم به‌درستی کار می‌کند',
                    style: AppTheme.cyberTextStyle(
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: deviceProvider.alarms.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final alarm = deviceProvider.alarms[index];
                return AlarmItem(alarm: alarm);
              },
            ),
    );
  }
}
