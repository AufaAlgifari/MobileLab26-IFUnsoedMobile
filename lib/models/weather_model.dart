class WeatherModel {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double precipitation;
  final int weatherCode;
  final double windSpeed;
  final String time;
  final int todayPrecipitationProbability;
  final double todayMaxTemp;
  final double todayMinTemp;

  const WeatherModel({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed,
    required this.time,
    required this.todayPrecipitationProbability,
    required this.todayMaxTemp,
    required this.todayMinTemp,
  });

  factory WeatherModel.fromApiJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>? ?? {};
    final daily = json['daily'] as Map<String, dynamic>? ?? {};

    final precipProbs = daily['precipitation_probability_max'] as List<dynamic>?;
    final maxTemps = daily['temperature_2m_max'] as List<dynamic>?;
    final minTemps = daily['temperature_2m_min'] as List<dynamic>?;

    final todayPrecipProb = (precipProbs != null && precipProbs.isNotEmpty)
        ? (precipProbs[0] as num?)?.toInt() ?? 0
        : 0;
    final todayMax = (maxTemps != null && maxTemps.isNotEmpty)
        ? (maxTemps[0] as num?)?.toDouble() ?? 0.0
        : 0.0;
    final todayMin = (minTemps != null && minTemps.isNotEmpty)
        ? (minTemps[0] as num?)?.toDouble() ?? 0.0
        : 0.0;

    return WeatherModel(
      temperature: (current['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature: (current['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (current['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      precipitation: (current['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (current['weather_code'] as num?)?.toInt() ?? 0,
      windSpeed: (current['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      time: current['time'] as String? ?? '',
      todayPrecipitationProbability: todayPrecipProb,
      todayMaxTemp: todayMax,
      todayMinTemp: todayMin,
    );
  }
}
