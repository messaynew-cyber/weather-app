import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _service = WeatherService();
  final TextEditingController _cityController = TextEditingController(text: 'Addis Ababa');
  WeatherData? _weather;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    setState(() { _loading = true; _error = null; });
    try {
      final data = await _service.getWeather(_cityController.text.trim());
      setState(() { _weather = data; _loading = false; });
    } catch (e) {
      setState(() { _error = 'City not found. Try another.'; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final temp = _weather?.current.tempC ?? 20;
    final bgColor = temp > 30 ? const Color(0xFF4A1C0E)
        : temp > 20 ? const Color(0xFF3D2E0B)
        : temp > 10 ? const Color(0xFF0B2E3D)
        : const Color(0xFF1A1A3E);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchWeather,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Search city...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white70),
                      onPressed: _fetchWeather,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  onSubmitted: (_) => _fetchWeather(),
                ),
              ),
              
              const SizedBox(height: 20),
              
              if (_loading) ...[
                const SizedBox(height: 100),
                const Center(child: CircularProgressIndicator(color: Colors.white54)),
              ] else if (_error != null) ...[
                const SizedBox(height: 100),
                Center(
                  child: Column(
                    children: [
                      const Text('🔍', style: TextStyle(fontSize: 48)),
                      const SizedBox(height: 12),
                      Text(_error!, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
                    ],
                  ),
                ),
              ] else if (_weather != null) ...[
                CurrentWeatherCard(
                  weather: _weather!.current,
                  city: _weather!.city,
                  service: _service,
                ),
                const SizedBox(height: 20),
                Text('3-Day Forecast', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.8))),
                const SizedBox(height: 12),
                ForecastRow(forecast: _weather!.forecast, service: _service),
                const SizedBox(height: 20),
                // Extra details
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _detail('🧭', _weather!.current.windDir, 'Wind Dir'),
                      _detail('📊', '\${_weather!.current.pressureMb.round()} mb', 'Pressure'),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 40),
              Center(
                child: Text(
                  'Powered by wttr.in • No API keys needed',
                  style: TextStyle(color: Colors.white.withOpacity(0.25), fontSize: 11),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detail(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
      ],
    );
  }
}
