import 'package:intl/intl.dart';

class DailyForecastModel {
  final String dateString;
  final DateTime? date;
  final int weatherCode;
  final double maxTemp;
  final double minTemp;
  final int precipitationProbability;

  const DailyForecastModel({
    required this.dateString,
    this.date,
    required this.weatherCode,
    required this.maxTemp,
    required this.minTemp,
    required this.precipitationProbability,
  });

  String get formattedDayName {
    if (date == null) return dateString;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date!.year, date!.month, date!.day);

    if (target == today) {
      return 'Hari Ini';
    } else if (target == today.add(const Duration(days: 1))) {
      return 'Besok';
    } else {
      // e.g. "Senin, 26 Nov"
      return DateFormat('EEEE, d MMM', 'id_ID').format(date!);
    }
  }

  static List<DailyForecastModel> fromDailyJson(Map<String, dynamic> daily) {
    final times = daily['time'] as List<dynamic>? ?? [];
    final codes = daily['weather_code'] as List<dynamic>? ?? [];
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>? ?? [];
    final minTemps = daily['temperature_2m_min'] as List<dynamic>? ?? [];
    final precipProbs = daily['precipitation_probability_max'] as List<dynamic>? ?? [];

    final list = <DailyForecastModel>[];
    for (int i = 0; i < times.length; i++) {
      final dateStr = times[i].toString();
      DateTime? parsedDate;
      try {
        parsedDate = DateTime.parse(dateStr);
      } catch (_) {
        parsedDate = null;
      }

      list.add(
        DailyForecastModel(
          dateString: dateStr,
          date: parsedDate,
          weatherCode: i < codes.length ? (codes[i] as num?)?.toInt() ?? 0 : 0,
          maxTemp: i < maxTemps.length ? (maxTemps[i] as num?)?.toDouble() ?? 0.0 : 0.0,
          minTemp: i < minTemps.length ? (minTemps[i] as num?)?.toDouble() ?? 0.0 : 0.0,
          precipitationProbability: i < precipProbs.length
              ? (precipProbs[i] as num?)?.toInt() ?? 0
              : 0,
        ),
      );
    }
    return list;
  }
}
