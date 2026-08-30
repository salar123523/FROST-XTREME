import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import '../../utils/theme.dart';

class CyberGauge extends StatelessWidget {
  final double value;
  final double minValue;
  final double maxValue;
  final String label;
  final Color color;

  const CyberGauge({
    super.key,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: AppTheme.cyberCardDecoration(),
      child: SfRadialGauge(
        axes: [
          RadialAxis(
            minimum: minValue,
            maximum: maxValue,
            radius: '70%',
            startAngle: 230,
            endAngle: 130,
            axisLineStyle: const AxisLineStyle(
              color: Color(0xFF2A2A4A),
              thickness: 8,
            ),
            pointers: [
              NeedlePointer(
                value: value,
                enableAnimation: true,
                animationDuration: 300,
                needleColor: color,
                needleLength: 0.6,
                knobStyle: KnobStyle(
                  color: color,
                  knobRadius: 0.08,
                  borderWidth: 2,
                  borderColor: Colors.white,
                ),
              ),
              RangePointer(
                value: value,
                width: 8,
                color: color.withOpacity(0.8),
                gradient: SweepGradient(
                  colors: [color, color.withOpacity(0.3)],
                ),
              ),
            ],
            annotations: [
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      value.toStringAsFixed(1),
                      style: AppTheme.orbitronTextStyle(size: 32),
                    ),
                    Text(
                      '$label°C',
                      style: AppTheme.cyberTextStyle(
                        size: 14,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                angle: 90,
                positionFactor: 0.5,
              ),
            ],
            ranges: [
              GaugeRange(
                startValue: minValue,
                endValue: 10,
                color: AppTheme.primaryColor.withOpacity(0.2),
                label: 'خنک',
                labelStyle: const GaugeTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              GaugeRange(
                startValue: 10,
                endValue: 20,
                color: AppTheme.accentColor.withOpacity(0.2),
                label: 'معمولی',
                labelStyle: const GaugeTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
              GaugeRange(
                startValue: 20,
                endValue: maxValue,
                color: AppTheme.dangerColor.withOpacity(0.2),
                label: 'گرم',
                labelStyle: const GaugeTextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
