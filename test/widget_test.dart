import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_pawangcuaca/models/location_model.dart';
import 'package:responsi_pawangcuaca/models/weather_model.dart';
import 'package:responsi_pawangcuaca/core/utils/weather_code_mapper.dart';

void main() {
  test('LocationModel serialization and deserialization', () {
    const loc = LocationModel(
      id: 1,
      name: 'Jakarta',
      latitude: -6.2088,
      longitude: 106.8456,
      country: 'Indonesia',
      admin1: 'Jakarta',
      isFavorite: true,
    );

    final json = loc.toJson();
    final parsed = LocationModel.fromJson(json);

    expect(parsed.id, 1);
    expect(parsed.name, 'Jakarta');
    expect(parsed.isFavorite, true);
  });

  test('WeatherCodeMapper returns correct description and icon', () {
    expect(WeatherCodeMapper.getDescription(0), 'Cerah');
    expect(WeatherCodeMapper.getDescription(3), 'Mendung');
    expect(WeatherCodeMapper.getDescription(61), 'Hujan Ringan');
    expect(WeatherCodeMapper.getDescription(95), 'Badai Petir');
  });

  test('WeatherModel parse from API json format', () {
    final mockJson = {
      'current': {
        'time': '2026-11-25T10:00',
        'temperature_2m': 28.5,
        'relative_humidity_2m': 75,
        'apparent_temperature': 32.0,
        'precipitation': 1.2,
        'weather_code': 1,
        'wind_speed_10m': 10.5,
      },
      'daily': {
        'precipitation_probability_max': [60],
        'temperature_2m_max': [32.0],
        'temperature_2m_min': [24.0],
      }
    };

    final model = WeatherModel.fromApiJson(mockJson);
    expect(model.temperature, 28.5);
    expect(model.relativeHumidity, 75);
    expect(model.apparentTemperature, 32.0);
    expect(model.todayPrecipitationProbability, 60);
    expect(model.todayMaxTemp, 32.0);
    expect(model.todayMinTemp, 24.0);
  });
}
