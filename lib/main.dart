import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/theme/app_theme.dart';
import 'repositories/weather_repository.dart';
import 'services/geocoding_service.dart';
import 'services/local_storage_service.dart';
import 'services/weather_service.dart';
import 'viewmodels/search_viewmodel.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi locale formatting untuk nama hari & tanggal bahasa Indonesia
  await initializeDateFormatting('id_ID', null);

  final geocodingService = GeocodingService();
  final weatherService = WeatherService();
  final localStorageService = LocalStorageService();

  final weatherRepository = WeatherRepository(
    geocodingService: geocodingService,
    weatherService: weatherService,
    storageService: localStorageService,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<WeatherRepository>.value(value: weatherRepository),
        ChangeNotifierProvider<WeatherViewModel>(
          create: (_) => WeatherViewModel(repository: weatherRepository),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (_) => SearchViewModel(repository: weatherRepository),
        ),
      ],
      child: const PawangCuacaApp(),
    ),
  );
}

class PawangCuacaApp extends StatelessWidget {
  const PawangCuacaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pawang Cuaca',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const HomeScreen(),
    );
  }
}
