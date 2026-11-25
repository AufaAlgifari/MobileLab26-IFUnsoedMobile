import 'package:flutter/material.dart';

class WeatherCodeMapper {
  /// Mendapatkan deskripsi bahasa Indonesia untuk WMO weather_code
  static String getDescription(int? code) {
    if (code == null) return 'Tidak Diketahui';

    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah Berawan';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Mendung';
      case 45:
      case 48:
        return 'Berkabut';
      case 51:
        return 'Gerimis Ringan';
      case 53:
        return 'Gerimis Sedang';
      case 55:
        return 'Gerimis Lebat';
      case 56:
      case 57:
        return 'Gerimis Membeku';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
      case 67:
        return 'Hujan Membeku';
      case 71:
        return 'Salju Ringan';
      case 73:
        return 'Salju Sedang';
      case 75:
        return 'Salju Lebat';
      case 77:
        return 'Butiran Salju';
      case 80:
        return 'Hujan Lokal Ringan';
      case 81:
        return 'Hujan Lokal Sedang';
      case 82:
        return 'Hujan Lokal Deras';
      case 85:
      case 86:
        return 'Hujan Salju Lokal';
      case 95:
        return 'Badai Petir';
      case 96:
      case 99:
        return 'Badai Petir & Hujan Es';
      default:
        return 'Kondisi Cuaca ($code)';
    }
  }

  /// Mendapatkan icon Material yang sesuai untuk WMO weather_code
  static IconData getIcon(int? code) {
    if (code == null) return Icons.wb_sunny_rounded;

    switch (code) {
      case 0:
        return Icons.wb_sunny_rounded;
      case 1:
        return Icons.wb_cloudy_rounded;
      case 2:
        return Icons.cloud_queue_rounded;
      case 3:
        return Icons.cloud_rounded;
      case 45:
      case 48:
        return Icons.waves_rounded;
      case 51:
      case 53:
      case 55:
        return Icons.grain_rounded;
      case 56:
      case 57:
        return Icons.ac_unit_rounded;
      case 61:
        return Icons.water_drop_outlined;
      case 63:
      case 65:
        return Icons.water_drop_rounded;
      case 66:
      case 67:
        return Icons.severe_cold_rounded;
      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit_rounded;
      case 80:
      case 81:
      case 82:
        return Icons.umbrella_rounded;
      case 85:
      case 86:
        return Icons.ac_unit_rounded;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm_rounded;
      default:
        return Icons.wb_cloudy_rounded;
    }
  }
}
