import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../models/weather_model.dart';

class WeatherDetailSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailSection({
    super.key,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detail Cuaca',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkest,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                icon: Icons.water_drop_rounded,
                iconColor: AppColors.primary,
                label: 'Kelembapan',
                value: '${weather.relativeHumidity}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DetailCard(
                icon: Icons.air_rounded,
                iconColor: AppColors.primary,
                label: 'Kecepatan Angin',
                value: '${weather.windSpeed} km/j',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _DetailCard(
                icon: Icons.umbrella_rounded,
                iconColor: AppColors.primary,
                label: 'Peluang Hujan',
                value: '${weather.todayPrecipitationProbability}%',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _DetailCard(
                icon: Icons.grain_rounded,
                iconColor: AppColors.primary,
                label: 'Curah Hujan',
                value: '${weather.precipitation} mm',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DetailCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _DetailCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.light.withAlpha(60)),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withAlpha(15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.lightest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkest,
            ),
          ),
        ],
      ),
    );
  }
}
