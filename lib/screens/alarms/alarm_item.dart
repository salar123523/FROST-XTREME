import 'package:flutter/material.dart';
import '../../models/alarm.dart';
import '../../utils/theme.dart';

class AlarmItem extends StatelessWidget {
  final Alarm alarm;

  const AlarmItem({super.key, required this.alarm});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: alarm.color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: alarm.color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: alarm.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              alarm.icon,
              color: alarm.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alarm.typeName,
                  style: AppTheme.cyberTextStyle(
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                Text(
                  alarm.message,
                  style: AppTheme.cyberTextStyle(
                    size: 13,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  '${alarm.timestamp.hour.toString().padLeft(2, '0')}:'
                  '${alarm.timestamp.minute.toString().padLeft(2, '0')}',
                  style: AppTheme.cyberTextStyle(
                    size: 11,
                    color: AppTheme.textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: alarm.color,
              boxShadow: [
                BoxShadow(
                  color: alarm.color.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
