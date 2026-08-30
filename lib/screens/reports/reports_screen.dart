import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/device_provider.dart';
import '../../services/report_service.dart';
import '../../utils/helpers.dart';
import '../../utils/theme.dart';
import 'report_card.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ReportService _reportService = ReportService();
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final deviceProvider = Provider.of<DeviceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'گزارشات',
          style: AppTheme.orbitronTextStyle(size: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _generateReport,
            tooltip: 'خروجی PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ReportCard(
              title: 'گزارش عملکرد',
              subtitle: 'بازه ۲۴ ساعته',
              icon: Icons.timeline,
              color: AppTheme.primaryColor,
              onTap: () => _generateReport(),
            ),
            const SizedBox(height: 12),
            ReportCard(
              title: 'گزارش مصرف انرژی',
              subtitle: 'بازه هفتگی',
              icon: Icons.electric_bolt,
              color: AppTheme.accentColor,
              onTap: () => _generateReport(),
            ),
            const SizedBox(height: 12),
            ReportCard(
              title: 'گزارش خطاها',
              subtitle: '${deviceProvider.allAlarms.length} خطا',
              icon: Icons.warning,
              color: AppTheme.dangerColor,
              onTap: () => _generateReport(),
            ),
            const SizedBox(height: 12),
            ReportCard(
              title: 'گزارش کامل سیستم',
              subtitle: 'همه داده‌ها',
              icon: Icons.file_present,
              color: AppTheme.secondaryColor,
              onTap: () => _generateReport(),
            ),
            if (_isGenerating)
              const Padding(
                padding: EdgeInsets.all(16),
                child: LinearProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _generateReport() async {
    setState(() => _isGenerating = true);
    try {
      final reportData = Provider.of<DeviceProvider>(context, listen: false);
      await _reportService.generatePDF(reportData.currentData);
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'گزارش با موفقیت ذخیره شد',
          color: AppTheme.successColor,
        );
      }
    } catch (e) {
      if (mounted) {
        Helpers.showSnackBar(
          context,
          'خطا در ذخیره گزارش: $e',
          color: AppTheme.dangerColor,
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }
}
