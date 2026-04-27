import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ResultScreen extends StatefulWidget {
  final int prediction;
  final List<String> recommendations;

  const ResultScreen({
    Key? key,
    required this.prediction,
    required this.recommendations,
  }) : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<IconData> _getRecommendationIcons() {
    if (widget.prediction == 1) {
      return [
        Icons.medical_services,
        Icons.restaurant,
        Icons.directions_run,
        Icons.trending_up,
        Icons.favorite,
        Icons.track_changes,
      ];
    } else {
      return [
        Icons.check_circle,
        Icons.directions_run,
        Icons.restaurant,
        Icons.nights_stay,
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isHighRisk = widget.prediction == 1;
    final icons = _getRecommendationIcons();

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Hasil Skrining'),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Risk Level Card with Animation
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isHighRisk
                          ? [AppColors.warningRed, AppColors.cautionOrange]
                          : [AppColors.accentGreen, AppColors.primaryTeal],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (isHighRisk
                                ? AppColors.warningRed
                                : AppColors.accentGreen)
                            .withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isHighRisk
                              ? Icons.warning_rounded
                              : Icons.check_circle_rounded,
                          color: Colors.white,
                          size: 56,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isHighRisk
                            ? 'Risiko Diabetes Tinggi'
                            : 'Risiko Diabetes Rendah',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        isHighRisk
                            ? 'Segera lakukan konsultasi dengan tenaga medis'
                            : 'Pertahankan gaya hidup sehat Anda',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Recommendations Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lightbulb_outline,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Rekomendasi Kesehatan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.recommendations.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final isMainHeader = index == 0;
                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isMainHeader
                              ? (isHighRisk
                                  ? AppColors.warningRed.withOpacity(0.08)
                                  : AppColors.accentGreen.withOpacity(0.08))
                              : AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isMainHeader
                                ? (isHighRisk
                                    ? AppColors.warningRed.withOpacity(0.3)
                                    : AppColors.accentGreen.withOpacity(0.3))
                                : AppColors.borderColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (index < icons.length)
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isMainHeader
                                      ? (isHighRisk
                                          ? AppColors.warningRed.withOpacity(0.2)
                                          : AppColors.accentGreen.withOpacity(0.2))
                                      : AppColors.primaryBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  icons[index],
                                  color: isMainHeader
                                      ? (isHighRisk
                                          ? AppColors.warningRed
                                          : AppColors.accentGreen)
                                      : AppColors.primaryBlue,
                                  size: 20,
                                ),
                              ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                widget.recommendations[index],
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isMainHeader
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isMainHeader
                                      ? (isHighRisk
                                          ? AppColors.warningRed
                                          : AppColors.accentGreen)
                                      : AppColors.textSecondary,
                                  height: 1.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 20),
                  label: const Text(
                    'Kembali ke Skrining',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
