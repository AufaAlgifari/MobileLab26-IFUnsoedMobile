import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../repositories/weather_repository.dart';
import 'weather_viewmodel.dart';

class SearchViewModel extends ChangeNotifier {
  final WeatherRepository _repository;

  SearchViewModel({WeatherRepository? repository})
      : _repository = repository ?? WeatherRepository();

  ViewState _state = ViewState.initial;
  List<LocationModel> _searchResults = [];
  List<LocationModel> _favorites = [];
  List<LocationModel> _searchHistory = [];
  String? _errorMessage;
  String _currentQuery = '';
  Timer? _debounceTimer;

  ViewState get state => _state;
  List<LocationModel> get searchResults => _searchResults;
  List<LocationModel> get favorites => _favorites;
  List<LocationModel> get searchHistory => _searchHistory;
  String? get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  /// Memuat data favorit dan riwayat pencarian
  Future<void> loadInitialData() async {
    _favorites = await _repository.getFavorites();
    _searchHistory = await _repository.getSearchHistory();
    notifyListeners();
  }

  /// Pencarian dengan Debounce 450ms sesuai anjuran spesifikasi
  void onQueryChanged(String query) {
    _currentQuery = query;
    _debounceTimer?.cancel();

    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _searchResults = [];
      _state = ViewState.initial;
      _errorMessage = null;
      notifyListeners();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 450), () {
      executeSearch(trimmed);
    });
  }

  /// Eksekusi pencarian ke Geocoding API
  Future<void> executeSearch(String query) async {
    if (query.trim().isEmpty) return;

    _state = ViewState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await _repository.searchLocations(query.trim());
      _searchResults = results;

      if (results.isEmpty) {
        _state = ViewState.empty;
      } else {
        _state = ViewState.success;
      }
    } on SocketException {
      _errorMessage = 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
      _state = ViewState.error;
    } catch (e) {
      _errorMessage = 'Gagal mencari lokasi: ${e.toString().replaceAll("Exception: ", "")}';
      _state = ViewState.error;
    } finally {
      notifyListeners();
    }
  }

  /// Toggle status favorit suatu lokasi
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = await _repository.isFavorite(location);
    if (isFav) {
      await _repository.removeFavorite(location);
    } else {
      await _repository.addFavorite(location);
    }

    await loadInitialData();

    // Perbarui status pada hasil pencarian yang sedang aktif
    _searchResults = _searchResults.map((loc) {
      if (loc.id == location.id) {
        return loc.copyWith(isFavorite: !isFav);
      }
      return loc;
    }).toList();

    notifyListeners();
  }

  /// Bersihkan seluruh riwayat pencarian
  Future<void> clearSearchHistory() async {
    await _repository.clearSearchHistory();
    _searchHistory = [];
    notifyListeners();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
