import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../models/location_model.dart';
import '../viewmodels/search_viewmodel.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'widgets/location_tile.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchViewModel>().loadInitialData();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSelectLocation(LocationModel location) {
    context.read<WeatherViewModel>().selectLocation(location);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final searchVM = context.watch<SearchViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian Lokasi'),
      ),
      body: Column(
        children: [
          // Input Kolom Pencarian
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.lightest,
            child: TextField(
              controller: _searchController,
              autofocus: false,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                hintText: 'Ketik nama kota (mis. Jakarta, Bandung, Tokyo)...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () {
                          _searchController.clear();
                          searchVM.onQueryChanged('');
                        },
                      )
                    : null,
              ),
              onChanged: (val) {
                searchVM.onQueryChanged(val);
                setState(() {});
              },
              onSubmitted: (val) {
                searchVM.executeSearch(val);
              },
            ),
          ),

          // Tampilan Konten (Hasil Pencarian ATAU Riwayat & Favorit)
          Expanded(
            child: _buildBody(searchVM),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchViewModel vm) {
    // 1. Jika pengguna sedang mengetik / mencari
    if (_searchController.text.trim().isNotEmpty) {
      switch (vm.state) {
        case ViewState.loading:
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 12),
                Text(
                  'Mencari kota di Geocoding API...',
                  style: TextStyle(color: AppColors.darkest),
                ),
              ],
            ),
          );

        case ViewState.empty:
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.location_off_rounded,
                  size: 56,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Kota tidak ditemukan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkest,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tidak ada hasil untuk "${_searchController.text.trim()}".\nPeriksa ejaan atau gunakan nama kota lain.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );

        case ViewState.error:
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
                  const SizedBox(height: 12),
                  Text(
                    vm.errorMessage ?? 'Gagal mencari lokasi',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.darkest, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.executeSearch(_searchController.text),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );

        case ViewState.initial:
        case ViewState.success:
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: vm.searchResults.length,
            itemBuilder: (context, index) {
              final loc = vm.searchResults[index];
              return LocationTile(
                location: loc,
                onTap: () => _onSelectLocation(loc),
                onToggleFavorite: () => vm.toggleFavorite(loc),
              );
            },
          );
      }
    }

    // 2. Jika input kosong, tampilkan Lokasi Favorit dan Riwayat Pencarian
    final hasFavorites = vm.favorites.isNotEmpty;
    final hasHistory = vm.searchHistory.isNotEmpty;

    if (!hasFavorites && !hasHistory) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.light.withAlpha(40),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.travel_explore_rounded,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Cari Kota di Seluruh Dunia',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkest,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Ketik nama kota di kotak pencarian di atas untuk melihat perkiraan cuaca terkini.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 12),
      children: [
        // Bagian Favorit
        if (hasFavorites) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: Colors.amber, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Lokasi Favorit',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkest,
                  ),
                ),
                const Spacer(),
                Text(
                  '${vm.favorites.length} tersimpan',
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          ...vm.favorites.map(
            (loc) => LocationTile(
              location: loc,
              onTap: () => _onSelectLocation(loc),
              onToggleFavorite: () => vm.toggleFavorite(loc),
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Bagian Riwayat Pencarian
        if (hasHistory) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Icon(Icons.history_rounded, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                const Text(
                  'Riwayat Pencarian',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkest,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => vm.clearSearchHistory(),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text('Hapus'),
                ),
              ],
            ),
          ),
          ...vm.searchHistory.map(
            (loc) => LocationTile(
              location: loc,
              onTap: () => _onSelectLocation(loc),
              onToggleFavorite: () => vm.toggleFavorite(loc),
            ),
          ),
        ],
      ],
    );
  }
}
