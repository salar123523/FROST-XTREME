import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/theme.dart';
import 'settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تنظیمات پیشرفته',
          style: AppTheme.orbitronTextStyle(size: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              color: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SettingsTile(
                      title: 'دمای هدف',
                      subtitle:
                          '${settings.targetTemperature.toStringAsFixed(1)}°C',
                      onChanged: (value) =>
                          settings.setTargetTemperature(value),
                      min: 0,
                      max: 30,
                      value: settings.targetTemperature,
                      icon: Icons.thermostat,
                    ),
                    const Divider(color: Colors.grey, height: 24),
                    SettingsTile(
                      title: 'تأخیر کمپرسور',
                      subtitle: '${settings.compressorDelay} ثانیه',
                      onChanged: (value) =>
                          settings.setCompressorDelay(value.toInt()),
                      min: 1,
                      max: 10,
                      value: settings.compressorDelay.toDouble(),
                      icon: Icons.timer,
                    ),
                    const Divider(color: Colors.grey, height: 24),
                    SettingsTile(
                      title: 'هیسترزیس',
                      subtitle: '${settings.hysteresis.toStringAsFixed(1)}°C',
                      onChanged: (value) => settings.setHysteresis(value),
                      min: 0.5,
                      max: 5,
                      value: settings.hysteresis,
                      icon: Icons.compare_arrows,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'صدا',
                        style: AppTheme.cyberTextStyle(),
                      ),
                      subtitle: Text(
                        'فعال/غیرفعال کردن صداها',
                        style: AppTheme.cyberTextStyle(
                          size: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      value: settings.soundEnabled,
                      onChanged: settings.setSoundEnabled,
                      activeColor: AppTheme.primaryColor,
                    ),
                    SwitchListTile(
                      title: Text(
                        'نوتیفیکیشن',
                        style: AppTheme.cyberTextStyle(),
                      ),
                      subtitle: Text(
                        'فعال/غیرفعال کردن هشدارها',
                        style: AppTheme.cyberTextStyle(
                          size: 12,
                          color: AppTheme.textSecondaryColor,
                        ),
                      ),
                      value: settings.notificationsEnabled,
                      onChanged: settings.setNotificationsEnabled,
                      activeColor: AppTheme.primaryColor,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: AppTheme.dangerColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppTheme.dangerColor.withOpacity(0.3),
                ),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.restore,
                  color: AppTheme.dangerColor,
                ),
                title: Text(
                  'بازنشانی به تنظیمات کارخانه',
                  style: AppTheme.cyberTextStyle(color: AppTheme.dangerColor),
                ),
                onTap: () => _showResetDialog(context),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.textSecondaryColor,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FROST XTREME',
                          style: AppTheme.orbitronTextStyle(size: 14),
                        ),
                        Text(
                          'نسخه 1.0.0',
                          style: AppTheme.cyberTextStyle(
                            size: 12,
                            color: AppTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'بازنشانی تنظیمات',
          style: AppTheme.orbitronTextStyle(size: 18),
        ),
        content: Text(
          'آیا از بازنشانی به تنظیمات کارخانه اطمینان دارید؟',
          style: AppTheme.cyberTextStyle(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'لغو',
              style:
                  AppTheme.cyberTextStyle(color: AppTheme.textSecondaryColor),
            ),
          ),
          TextButton(
            onPressed: () {
              Provider.of<SettingsProvider>(context, listen: false)
                  .resetSettings();
              Navigator.pop(context);
            },
            child: Text(
              'بازنشانی',
              style: AppTheme.cyberTextStyle(color: AppTheme.dangerColor),
            ),
          ),
        ],
      ),
    );
  }
}
