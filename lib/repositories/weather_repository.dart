import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../models/daily_forecast_model.dart';
import '../services/geocoding_service.dart';
import '../services/weather_service.dart';
import '../services/local_storage_service.dart';

class WeatherRepository {
  final GeocodingService _geocodingService;
  final WeatherService _weatherService;
  final LocalStorageService _storageService;

  WeatherRepository({
    GeocodingService? geocodingService,
    WeatherService? weatherService,
    LocalStorageService? storageService,
  })  : _geocodingService = geocodingService ?? GeocodingService(),
        _weatherService = weatherService ?? WeatherService(),
        _storageService = storageService ?? LocalStorageService();

  /// Pencarian lokasi dan sinkronisasi status favorit
  Future<List<LocationModel>> searchLocations(String query) async {
    final locations = await _geocodingService.searchCities(query);
    final favorites = await _storageService.getFavorites();

    final favIds = favorites.map((e) => e.id).toSet();
    final favNames = favorites.map((e) => '${e.name}_${e.latitude}_${e.longitude}').toSet();

    return locations.map((loc) {
      final isFav = favIds.contains(loc.id) ||
          favNames.contains('${loc.name}_${loc.latitude}_${loc.longitude}');
      return loc.copyWith(isFavorite: isFav);
    }).toList();
  }

  /// Mengambil cuaca terkini dan forecast 7 hari
  Future<({WeatherModel current, List<DailyForecastModel> daily})> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final json = await _weatherService.fetchForecast(
      latitude: latitude,
      longitude: longitude,
    );

    final current = WeatherModel.fromApiJson(json);
    final daily = DailyForecastModel.fromDailyJson(
      json['daily'] as Map<String, dynamic>? ?? {},
    );

    return (current: current, daily: daily);
  }

  // Local Storage Delegations
  Future<List<LocationModel>> getFavorites() => _storageService.getFavorites();

  Future<void> addFavorite(LocationModel location) => _storageService.addFavorite(location);

  Future<void> removeFavorite(LocationModel location) => _storageService.removeFavorite(location);

  Future<bool> isFavorite(LocationModel location) => _storageService.isFavorite(location);

  Future<List<LocationModel>> getSearchHistory() async {
    final history = await _storageService.getSearchHistory();
    final favorites = await _storageService.getFavorites();
    final favIds = favorites.map((e) => e.id).toSet();

    return history.map((loc) {
      return loc.copyWith(isFavorite: favIds.contains(loc.id));
    }).toList();
  }

  Future<void> addToSearchHistory(LocationModel location) =>
      _storageService.addToSearchHistory(location);

  Future<void> clearSearchHistory() => _storageService.clearSearchHistory();

  Future<void> saveLastSelectedLocation(LocationModel location) =>
      _storageService.saveLastSelectedLocation(location);

  Future<LocationModel?> getLastSelectedLocation() =>
      _storageService.getLastSelectedLocation();
}
