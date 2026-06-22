import 'package:flutter/material.dart';
import '../models/weather.dart';
import '../services/weather_service.dart';

class ForecastRow extends StatelessWidget {
  final List<DayForecast> forecast;
  final WeatherService service;
  
  const ForecastRow({super.key, required this.forecast, required this.service});
  
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = ['Today', 'Tomorrow', ()=> {
      final d = now.add(const Duration(days: 2));
      return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'][d.weekday % 7];
    }()];
    
    return Row(
      children: List.generate(forecast.length, (i) {
        final f = forecast[i];
        final icon = service.getWeatherIcon(f.condition.description, f.condition.code);
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(days[i], style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 8),
                Text('\${f.maxTempC.round()}°', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                Text('\${f.minTempC.round()}°', style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5))),
              ],
            ),
          ),
        );
      }),
    );
  }
}
