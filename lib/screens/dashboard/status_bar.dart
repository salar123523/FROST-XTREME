import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class StatusBar extends StatelessWidget {
  final bool compressorOn;
  final bool pumpOn;
  final bool coolingMode;
  final bool isConnected;
  final VoidCallback onCompressorTap;
  final VoidCallback onPumpTap;
  final VoidCallback onCoolingTap;

  const StatusBar({
    super.key,
    required this.compressorOn,
    required this.pumpOn,
    required this.coolingMode,
    required this.isConnected,
    required this.onCompressorTap,
    required this.onPumpTap,
    required this.onCoolingTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cyberCardDecoration(),
      child: Row(
        children: [
          _buildStatusItem(
            label: 'کمپرسور',
            isOn: compressorOn,
            color: AppTheme.dangerColor,
            onTap: onCompressorTap,
          ),
          const SizedBox(width: 12),
          _buildStatusItem(
            label: 'پمپ آب',
            isOn: pumpOn,
            color: AppTheme.successColor,
            onTap: onPumpTap,
          ),
          const SizedBox(width: 12),
          _buildStatusItem(
            label: 'حالت خنک',
            isOn: coolingMode,
            color: AppTheme.primaryColor,
            onTap: onCoolingTap,
          ),
          const SizedBox(width: 12),
          _buildStatusItem(
            label: 'اتصال',
            isOn: isConnected,
            color: AppTheme.warningColor,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required String label,
    required bool isOn,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isOn ? color.withOpacity(0.2) : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isOn ? color : Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn ? color : Colors.grey[700],
                  boxShadow: isOn
                      ? [
                          BoxShadow(
                            color: color.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTheme.cyberTextStyle(
                  size: 11,
                  color: isOn ? Colors.white : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
