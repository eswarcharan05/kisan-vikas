import 'dart:convert';
import 'package:http/http.dart' as http;

const String openWeatherMapApiKey = 'ca11ac3f41ac58285a93a9a4c706933e';

/// Fetch detailed current weather from OpenWeatherMap.
Future<Map<String, dynamic>> getDetailedCurrentWeather(double lat, double lon) async {
  final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherMapApiKey&units=metric"
  );
  final response = await http.get(url);
  print("Detailed Weather - Status code: ${response.statusCode}");
  print("Detailed Weather - Response body: ${response.body}");
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final temperature = (data['main']['temp'] as num).toDouble();
    final humidity = (data['main']['humidity'] as num).toDouble();
    final windSpeed = (data['wind']['speed'] as num).toDouble();
    final rainfall = data['rain'] != null && data['rain']['1h'] != null
        ? (data['rain']['1h'] as num).toDouble()
        : 0.0;
    return {
      'temperature': temperature,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'rainfall': rainfall,
    };
  } else {
    throw Exception("Failed to load detailed current weather");
  }
}

/// Convenience function to fetch and analyze full climate data using only current weather.
/// Since the 7-day forecast endpoint is not working for your API key,
/// this function returns the current weather along with placeholder forecast data.
Future<Map<String, dynamic>> fetchFullClimateAnalysis(double lat, double lon) async {
  final currentWeather = await getDetailedCurrentWeather(lat, lon);

  // Since forecast data is not available, provide placeholder information.
  String forecastSummary = "Forecast data not available for this API key.";
  List<String> customAlerts = ["Forecast data not available."];

  return {
    'currentWeather': currentWeather,
    'forecastSummary': forecastSummary,
    'customAlerts': customAlerts,
  };
}
