import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  static const String _baseUrl = 'https://wttr.in';
  
  Future<WeatherData> getWeather(String city) async {
    final url = Uri.parse('$_baseUrl/$city?format=j1');
    final response = await http.get(url);
    
    if (response.statusCode != 200) {
      throw Exception('Could not fetch weather for $city');
    }
    
    final json = jsonDecode(response.body);
    final current = CurrentWeather.fromJson(json);
    
    final List<DayForecast> forecast = [];
    final weatherList = json['weather'] as List;
    for (int i = 0; i < weatherList.length && i < 3; i++) {
      final day = weatherList[i];
      final hourly = day['hourly'] as List;
      final midday = hourly.length > 4 ? hourly[4] : hourly[0];
      forecast.add(DayForecast(
        date: day['date'] ?? '',
        minTempC: double.tryParse(day['mintempC'] ?? '0') ?? 0,
        maxTempC: double.tryParse(day['maxtempC'] ?? '0') ?? 0,
        avgTempC: double.tryParse(day['avgtempC'] ?? '0') ?? 0,
        condition: WeatherCondition.fromJson(midday),
      ));
    }
    
    return WeatherData(city: city, current: current, forecast: forecast);
  }
  
  String getWeatherIcon(String description, int code) {
    final d = description.toLowerCase();
    if (d.contains('sunny') || d.contains('clear')) return '☀️';
    if (d.contains('partly cloudy')) return '⛅';
    if (d.contains('cloudy') || d.contains('overcast')) return '☁️';
    if (d.contains('mist') || d.contains('fog')) return '🌫️';
    if (d.contains('drizzle') || d.contains('light rain')) return '🌦️';
    if (d.contains('rain') || d.contains('shower')) return '🌧️';
    if (d.contains('thunder') || d.contains('storm')) return '⛈️';
    if (d.contains('snow')) return '🌨️';
    if (d.contains('sleet')) return '🌨️';
    return '🌡️';
  }
}
