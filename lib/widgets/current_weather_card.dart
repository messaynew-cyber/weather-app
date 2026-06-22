import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class CurrentWeatherCard extends StatelessWidget {
  final CurrentWeather weather;
  final String city;
  final WeatherService service;
  
  const CurrentWeatherCard({
    super.key, required this.weather, required this.city, required this.service,
  });
  
  @override
  Widget build(BuildContext context) {
    final icon = service.getWeatherIcon(weather.condition.description, weather.condition.code);
    
    return Card(
      elevation: 0,
      color: Colors.white.withOpacity(0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Text(city, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5)),
            const SizedBox(height: 4),
            Text(weather.condition.description, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.7))),
            const SizedBox(height: 16),
            Text(icon, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 8),
            Text('\${weather.tempC.round()}°C', style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w200, color: Colors.white, height: 1)),
            Text('Feels like \${weather.feelsLikeC.round()}°C', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6))),
            const SizedBox(height: 28),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _stat('💧', '\${weather.humidity}%', 'Humidity'),
                _stat('💨', '\${weather.windKmph.round()} km/h', 'Wind'),
                _stat('👁️', '\${weather.visibilityKm.round()} km', 'Visibility'),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _stat(String icon, String value, String label) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5))),
      ],
    );
  }
}
