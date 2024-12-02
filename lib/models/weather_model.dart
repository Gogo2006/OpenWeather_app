// Weather class to organize the data read from the OpenWeather API json file

class Weather {
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;

  // Constructor: requires all instance variables to be explicitly declared during initialization
  Weather({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
  });

  // Method to translate data from the json file into information we can use
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'].toInt(),
      windSpeed: json['wind']['speed'].toDouble()
    );
  }
}