import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';

class GeocodingService {
  final http.Client _client;

  GeocodingService({http.Client? client}) : _client = client ?? http.Client();

  /// Mencari kota berdasarkan nama query
  Future<List<LocationModel>> searchCities(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) {
      return [];
    }

    final uri = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(cleanQuery)}&count=10&language=id&format=json',
    );

    try {
      final response = await _client.get(uri).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final results = data['results'] as List<dynamic>?;

        if (results == null || results.isEmpty) {
          return [];
        }

        return results
            .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw HttpException('Gagal memuat lokasi (Status ${response.statusCode})');
      }
    } on SocketException {
      throw const SocketException('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } catch (e) {
      rethrow;
    }
  }
}
