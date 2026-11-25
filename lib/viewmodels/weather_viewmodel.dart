import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../models/daily_forecast_model.dart';
import '../repositories/weather_repository.dart';

enum ViewState { initial, loading, success, empty, error }

class WeatherViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  WeatherViewModel({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository();

  ViewState _state = ViewState.initial;
  LocationModel? _selectedLocation;
  WeatherModel? _currentWeather;
  List<DailyForecastModel> _dailyForecast = [];
  String? _errorMessage;
  bool _isFavorite = false;

  ViewState get state => _state;
  LocationModel? get selectedLocation => _selectedLocation;
  WeatherModel? get currentWeather => _currentWeather;
  List<DailyForecastModel> get dailyForecast => _dailyForecast;
  String? get errorMessage => _errorMessage;
  bool get isFavorite => _isFavorite;

  // Default kota awal jika belum ada riwayat (Purwokerto / Banyumas)
  static const LocationModel defaultLocation = LocationModel(
    id: 1629001,
    name: 'Purwokerto',
    latitude: -7.4244,
    longitude: 109.2303,
    country: 'Indonesia',
    admin1: 'Jawa Tengah',
    timezone: 'Asia/Jakarta',
  );

  /// Inisialisasi awal: Muat lokasi terakhir yang disimpan atau default
  Future<void> init() async {
    final lastLocation = await _repository.getLastSelectedLocation();
    final locationToLoad = lastLocation ?? defaultLocation;
    await selectLocation(locationToLoad, saveToHistory: false);
  }

  /// Memilih lokasi baru dan memuat data cuaca
  Future<void> selectLocation(LocationModel location, {bool saveToHistory = true}) async {
    _selectedLocation = location;
    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      if (saveToHistory) {
        await _repository.saveLastSelectedLocation(location);
        await _repository.addToSearchHistory(location);
      }

      // Cek status favorit
      _isFavorite = await _repository.isFavorite(location);

      // Ambil data cuaca dari API
      final result = await _repository.getWeather(
        latitude: location.latitude,
        longitude: location.longitude,
      );

      _currentWeather = result.current;
      _dailyForecast = result.daily;
      _state = ViewState.success;
    } on SocketException {
      _errorMessage = 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
      _state = ViewState.error;
    } catch (e) {
      _errorMessage = 'Gagal memuat cuaca: ${e.toString().replaceAll("Exception: ", "")}';
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  /// Memperbarui data cuaca kota saat ini (Pull to Refresh)
  Future<void> refreshWeather() async {
    if (_selectedLocation == null) return;

    try {
      _isFavorite = await _repository.isFavorite(_selectedLocation!);
      final result = await _repository.getWeather(
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );

      _currentWeather = result.current;
      _dailyForecast = result.daily;
      _state = ViewState.success;
      _errorMessage = null;
    } on SocketException {
      _errorMessage = 'Tidak ada koneksi internet.';
    } catch (e) {
      _errorMessage = 'Gagal memperbarui cuaca: $e';
    } finally {
      notifyListeners();
    }
  }

  /// Mengubah status favorit untuk kota saat ini
  Future<void> toggleFavorite() async {
    if (_selectedLocation == null) return;

    final loc = _selectedLocation!;
    if (_isFavorite) {
      await _repository.removeFavorite(loc);
      _isFavorite = false;
    } else {
      await _repository.addFavorite(loc);
      _isFavorite = true;
    }
    _selectedLocation = _selectedLocation!.copyWith(isFavorite: _isFavorite);
    notifyListeners();
  }
}
