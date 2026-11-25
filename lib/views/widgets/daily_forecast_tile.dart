import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/weather_code_mapper.dart';
import '../../models/daily_forecast_model.dart';

class DailyForecastSection extends StatelessWidget {
  final List<DailyForecastModel> forecastList;

  const DailyForecastSection({
    super.key,
    required this.forecastList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perkiraan Cuaca 7 Hari',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkest,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.light.withAlpha(60)),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkest.withAlpha(15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: forecastList.length,
            separatorBuilder: (context, index) => Divider(
              color: AppColors.light.withAlpha(80),
              height: 1,
            ),
            itemBuilder: (context, index) {
              final item = forecastList[index];
              final icon = WeatherCodeMapper.getIcon(item.weatherCode);
              final desc = WeatherCodeMapper.getDescription(item.weatherCode);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    // Tanggal / Nama Hari
                    SizedBox(
                      width: 100,
                      child: Text(
                        item.formattedDayName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                          color: index == 0 ? AppColors.primary : AppColors.darkest,
                        ),
                      ),
                    ),

                    // Icon & Deskripsi
                    Expanded(
                      child: Row(
                        children: [
                          Icon(icon, color: AppColors.primary, size: 24),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              desc,
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Peluang Hujan jika ada
                    if (item.precipitationProbability > 0) ...[
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.water_drop, size: 12, color: AppColors.primary),
                          const SizedBox(width: 2),
                          Text(
                            '${item.precipitationProbability}%',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],

                    // Suhu Min / Max
                    Text(
                      '${item.maxTemp.round()}° / ${item.minTemp.round()}°',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkest,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
