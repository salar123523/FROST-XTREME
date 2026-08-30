import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../../models/device_data.dart';
import '../../providers/device_provider.dart';
import '../../utils/theme.dart';
import 'cyber_card.dart';
import 'cyber_gauge.dart';
import 'status_bar.dart';
import 'realtime_chart.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);
    final data = deviceProvider.currentData;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.ac_unit, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Text(
              'FROST XTREME',
              style: AppTheme.orbitronTextStyle(size: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi),
            color: data.isConnected ? AppTheme.successColor : Colors.grey,
            onPressed: () => deviceProvider.connectDevice(),
          ),
          IconButton(
            icon: const Icon(Icons.power_settings_new),
            color: data.isConnected ? AppTheme.successColor : Colors.grey,
            onPressed: () => deviceProvider.toggleCompressor(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => deviceProvider.connectDevice(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const AlwaysScrollableScrollPhysics(),
          child: AnimationLimiter(
            child: Column(
              children: [
                AnimationConfiguration.staggeredGrid(
                  position: 0,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 2,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          Expanded(
                            child: CyberCard(
                              title: 'دمای آب',
                              value: data.waterTemp,
                              unit: '°C',
                              icon: Icons.water_drop,
                              color: AppTheme.primaryColor,
                              progress: data.waterTemp / 30,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CyberCard(
                              title: 'دمای محیط',
                              value: data.ambientTemp,
                              unit: '°C',
                              icon: Icons.thermostat,
                              color: AppTheme.accentColor,
                              progress: (data.ambientTemp - 10) / 35,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimationConfiguration.staggeredGrid(
                  position: 1,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 2,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          Expanded(
                            child: CyberCard(
                              title: 'رطوبت',
                              value: data.humidity,
                              unit: '%',
                              icon: Icons.water,
                              color: AppTheme.secondaryColor,
                              progress: data.humidity / 100,
                              onTap: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CyberCard(
                              title: 'دبی آب',
                              value: data.flowRate,
                              unit: 'L/min',
                              icon: Icons.speed,
                              color: AppTheme.successColor,
                              progress: data.flowRate / 5,
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimationConfiguration.staggeredGrid(
                  position: 2,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 1,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: CyberGauge(
                        value: data.waterTemp,
                        minValue: 0,
                        maxValue: 30,
                        label: 'دمای آب',
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimationConfiguration.staggeredGrid(
                  position: 3,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 1,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: StatusBar(
                        compressorOn: data.compressorOn,
                        pumpOn: data.pumpOn,
                        coolingMode: data.coolingMode,
                        isConnected: data.isConnected,
                        onCompressorTap: deviceProvider.toggleCompressor,
                        onPumpTap: deviceProvider.togglePump,
                        onCoolingTap: deviceProvider.toggleCoolingMode,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimationConfiguration.staggeredGrid(
                  position: 4,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 1,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Container(
                        height: 150,
                        decoration: AppTheme.cyberCardDecoration(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: RealtimeChart(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                AnimationConfiguration.staggeredGrid(
                  position: 5,
                  duration: const Duration(milliseconds: 600),
                  columnCount: 1,
                  child: SlideAnimation(
                    verticalOffset: 50,
                    child: FadeInAnimation(
                      child: Card(
                        color: AppTheme.surfaceColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info,
                                color: AppTheme.primaryColor,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'وضعیت سیستم',
                                      style: AppTheme.cyberTextStyle(size: 14),
                                    ),
                                    Text(
                                      DeviceDataHelper.getStatusText(data),
                                      style: AppTheme.orbitronTextStyle(
                                        size: 16,
                                        color:
                                            DeviceDataHelper.getStatusColor(data),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        AppTheme.primaryColor.withOpacity(0.3),
                                  ),
                                ),
                                child: Text(
                                  '${DeviceDataHelper.calculateEfficiency(data).toInt()}%',
                                  style: AppTheme.orbitronTextStyle(
                                    size: 20,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
