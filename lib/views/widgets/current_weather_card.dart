import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../models/location_model.dart';
import '../../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final WeatherModel weather;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final weatherDesc = WeatherCodeMapper.getDescription(weather.weatherCode);
    final weatherIcon = WeatherCodeMapper.getIcon(weather.weatherCode);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.darkest,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkest.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Nama Kota & Wilayah
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 20),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  location.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (location.admin1 != null && location.admin1!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${location.admin1}, ${location.country ?? ''}',
              style: TextStyle(
                color: Colors.white.withAlpha(210),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 20),

          // Icon cuaca & Suhu Utama
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                weatherIcon,
                size: 80,
                color: AppColors.light,
              ),
              const SizedBox(width: 16),
              Text(
                '${weather.temperature.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 72,
                  fontWeight: FontWeight.w300,
                  height: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Deskripsi Cuaca
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weatherDesc,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Suhu yang dirasakan & Rentang suhu hari ini
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Terasa seperti ${weather.apparentTemperature.round()}°C',
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'H: ${weather.todayMaxTemp.round()}°  L: ${weather.todayMinTemp.round()}°',
                style: TextStyle(
                  color: Colors.white.withAlpha(220),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
