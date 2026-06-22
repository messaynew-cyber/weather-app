class WeatherCondition {
  final String description;
  final String icon;
  final int code;
  
  WeatherCondition({required this.description, required this.icon, required this.code});
  
  factory WeatherCondition.fromJson(Map<String, dynamic> json) {
    return WeatherCondition(
      description: json['weatherDesc'][0]['value'] ?? 'Unknown',
      icon: json['weatherCode']?.toString() ?? 'na',
      code: int.tryParse(json['weatherCode']?.toString() ?? '0') ?? 0,
    );
  }
}

class CurrentWeather {
  final double tempC;
  final double feelsLikeC;
  final int humidity;
  final double windKmph;
  final double visibilityKm;
  final double pressureMb;
  final String windDir;
  final WeatherCondition condition;
  
  CurrentWeather({
    required this.tempC, required this.feelsLikeC, required this.humidity,
    required this.windKmph, required this.visibilityKm, required this.pressureMb,
    required this.windDir, required this.condition,
  });
  
  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    final c = json['current_condition'][0];
    return CurrentWeather(
      tempC: double.tryParse(c['temp_C'] ?? '0') ?? 0,
      feelsLikeC: double.tryParse(c['FeelsLikeC'] ?? '0') ?? 0,
      humidity: int.tryParse(c['humidity'] ?? '0') ?? 0,
      windKmph: double.tryParse(c['windspeedKmph'] ?? '0') ?? 0,
      visibilityKm: double.tryParse(c['visibility'] ?? '0') ?? 0,
      pressureMb: double.tryParse(c['pressure'] ?? '0') ?? 0,
      windDir: c['winddir16Point'] ?? 'N',
      condition: WeatherCondition.fromJson(c),
    );
  }
}

class DayForecast {
  final String date;
  final double minTempC;
  final double maxTempC;
  final double avgTempC;
  final WeatherCondition condition;
  
  DayForecast({
    required this.date, required this.minTempC, required this.maxTempC,
    required this.avgTempC, required this.condition,
  });
}

class WeatherData {
  final String city;
  final CurrentWeather current;
  final List<DayForecast> forecast;
  
  WeatherData({required this.city, required this.current, required this.forecast});
}
