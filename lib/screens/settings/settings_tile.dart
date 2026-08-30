import 'package:flutter/material.dart';
import '../../utils/theme.dart';

class SettingsTile extends StatefulWidget {
  final String title;
  final String subtitle;
  final Function(double) onChanged;
  final double min;
  final double max;
  final double value;
  final IconData icon;

  const SettingsTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onChanged,
    required this.min,
    required this.max,
    required this.value,
    required this.icon,
  });

  @override
  State<SettingsTile> createState() => _SettingsTileState();
}

class _SettingsTileState extends State<SettingsTile> {
  late double _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant SettingsTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(widget.icon, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: AppTheme.cyberTextStyle(),
                  ),
                  Text(
                    widget.subtitle,
                    style: AppTheme.cyberTextStyle(
                      size: 12,
                      color: AppTheme.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Slider(
          value: _value,
          min: widget.min,
          max: widget.max,
          divisions: ((widget.max - widget.min) * 2).toInt(),
          activeColor: AppTheme.primaryColor,
          inactiveColor: Colors.grey[800],
          onChanged: (value) {
            setState(() => _value = value);
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
