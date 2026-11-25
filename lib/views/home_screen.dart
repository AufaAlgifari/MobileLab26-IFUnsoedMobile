import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../viewmodels/weather_viewmodel.dart';
import 'search_screen.dart';
import 'widgets/current_weather_card.dart';
import 'widgets/weather_detail_item.dart';
import 'widgets/daily_forecast_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<WeatherViewModel>(
          builder: (context, vm, _) {
            final locName = vm.selectedLocation?.name ?? 'Pawang Cuaca';
            return Text(
              locName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            );
          },
        ),
        actions: [
          // Tombol Bookmark / Favorit
          Consumer<WeatherViewModel>(
            builder: (context, vm, _) {
              if (vm.selectedLocation == null) return const SizedBox.shrink();
              return IconButton(
                icon: Icon(
                  vm.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: vm.isFavorite ? Colors.amber : Colors.white,
                  size: 28,
                ),
                tooltip: vm.isFavorite ? 'Hapus dari Favorit' : 'Simpan ke Favorit',
                onPressed: () {
                  vm.toggleFavorite();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        vm.isFavorite
                            ? '${vm.selectedLocation?.name} ditambahkan ke Favorit'
                            : '${vm.selectedLocation?.name} dihapus dari Favorit',
                      ),
                      duration: const Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              );
            },
          ),

          // Tombol Cari Lokasi
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 26),
            tooltip: 'Cari Kota',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, vm, _) {
          switch (vm.state) {
            case ViewState.loading:
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: AppColors.primary),
                    SizedBox(height: 16),
                    Text(
                      'Mengambil data cuaca...',
                      style: TextStyle(
                        color: AppColors.darkest,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );

            case ViewState.error:
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.light.withAlpha(50),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cloud_off_rounded,
                          size: 64,
                          color: AppColors.darkest,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        vm.errorMessage ?? 'Terjadi kesalahan saat memuat data',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.darkest,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => vm.refreshWeather(),
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              );

            case ViewState.initial:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wb_sunny_rounded, size: 64, color: AppColors.primary),
                    const SizedBox(height: 16),
                    const Text(
                      'Pilih kota untuk melihat informasi cuaca',
                      style: TextStyle(fontSize: 16, color: AppColors.darkest),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SearchScreen()),
                        );
                      },
                      icon: const Icon(Icons.search),
                      label: const Text('Cari Kota'),
                    ),
                  ],
                ),
              );

            case ViewState.empty:
            case ViewState.success:
              if (vm.selectedLocation == null || vm.currentWeather == null) {
                return const Center(child: Text('Data cuaca tidak tersedia'));
              }

              return RefreshIndicator(
                color: AppColors.primary,
                backgroundColor: Colors.white,
                onRefresh: () => vm.refreshWeather(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Kartu Cuaca Terkini
                      CurrentWeatherCard(
                        location: vm.selectedLocation!,
                        weather: vm.currentWeather!,
                      ),
                      const SizedBox(height: 20),

                      // Detail Cuaca (Kelembapan, Angin, Curah & Peluang Hujan)
                      WeatherDetailSection(
                        weather: vm.currentWeather!,
                      ),
                      const SizedBox(height: 20),

                      // Perkiraan Cuaca 7 Hari
                      if (vm.dailyForecast.isNotEmpty)
                        DailyForecastSection(
                          forecastList: vm.dailyForecast,
                        ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              );
          }
        },
      ),
    );
  }
}
