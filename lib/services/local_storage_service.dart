import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class LocalStorageService {
  static const String _keyFavorites = 'favorite_locations';
  static const String _keyHistory = 'search_history';
  static const String _keyLastSelected = 'last_selected_location';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  /// Mendapatkan daftar lokasi favorit
  Future<List<LocationModel>> getFavorites() async {
    final prefs = await _prefs;
    final jsonStringList = prefs.getStringList(_keyFavorites) ?? [];

    return jsonStringList.map((item) {
      final map = json.decode(item) as Map<String, dynamic>;
      return LocationModel.fromJson(map).copyWith(isFavorite: true);
    }).toList();
  }

  /// Menambah lokasi ke daftar favorit (mencegah duplikat berdasarkan id atau nama & koordinat)
  Future<void> addFavorite(LocationModel location) async {
    final prefs = await _prefs;
    final currentList = await getFavorites();

    final exists = currentList.any((item) =>
        item.id == location.id ||
        (item.name.toLowerCase() == location.name.toLowerCase() &&
            item.latitude == location.latitude &&
            item.longitude == location.longitude));

    if (!exists) {
      currentList.insert(0, location.copyWith(isFavorite: true));
      final encoded = currentList.map((e) => json.encode(e.toJson())).toList();
      await prefs.setStringList(_keyFavorites, encoded);
    }
  }

  /// Menghapus lokasi dari daftar favorit
  Future<void> removeFavorite(LocationModel location) async {
    final prefs = await _prefs;
    final currentList = await getFavorites();

    currentList.removeWhere((item) =>
        item.id == location.id ||
        (item.name.toLowerCase() == location.name.toLowerCase() &&
            item.latitude == location.latitude &&
            item.longitude == location.longitude));

    final encoded = currentList.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_keyFavorites, encoded);
  }

  /// Mengecek apakah suatu lokasi merupakan favorit
  Future<bool> isFavorite(LocationModel location) async {
    final currentList = await getFavorites();
    return currentList.any((item) =>
        item.id == location.id ||
        (item.name.toLowerCase() == location.name.toLowerCase() &&
            item.latitude == location.latitude &&
            item.longitude == location.longitude));
  }

  /// Mendapatkan riwayat pencarian (maksimal 10 item terbaru)
  Future<List<LocationModel>> getSearchHistory() async {
    final prefs = await _prefs;
    final jsonStringList = prefs.getStringList(_keyHistory) ?? [];

    return jsonStringList.map((item) {
      final map = json.decode(item) as Map<String, dynamic>;
      return LocationModel.fromJson(map);
    }).toList();
  }

  /// Menambahkan lokasi ke riwayat pencarian
  Future<void> addToSearchHistory(LocationModel location) async {
    final prefs = await _prefs;
    final currentList = await getSearchHistory();

    // Hapus jika sudah ada agar bergeser ke paling atas
    currentList.removeWhere((item) =>
        item.id == location.id ||
        (item.name.toLowerCase() == location.name.toLowerCase() &&
            item.latitude == location.latitude &&
            item.longitude == location.longitude));

    currentList.insert(0, location);

    // Batasi 10 riwayat terakhir
    final trimmedList = currentList.take(10).toList();
    final encoded = trimmedList.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList(_keyHistory, encoded);
  }

  /// Menghapus seluruh riwayat pencarian
  Future<void> clearSearchHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_keyHistory);
  }

  /// Menyimpan lokasi terakhir yang dipilih
  Future<void> saveLastSelectedLocation(LocationModel location) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLastSelected, json.encode(location.toJson()));
  }

  /// Mengambil lokasi terakhir yang dipilih
  Future<LocationModel?> getLastSelectedLocation() async {
    final prefs = await _prefs;
    final str = prefs.getString(_keyLastSelected);
    if (str == null || str.isEmpty) return null;

    try {
      final map = json.decode(str) as Map<String, dynamic>;
      return LocationModel.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
