import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../models/intervals_model.dart';
import '../models/quote_model.dart';
import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

// Class to access the OpenWeather API and get the name of the user's city based on their location
class WeatherService {
  static const currWeather = 'http://api.openweathermap.org/data/2.5/weather';
  static const upcomingWeather = 'http://api.openweathermap.org/data/2.5/forecast';
  static const randomQuote = "https://api.adviceslip.com/advice";
  final String api_key;

  WeatherService(this.api_key);

  // returns a Weather object corresponding to the city name
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse('$currWeather?q=$cityName&appid=$api_key&units=imperial'));

    if(response.statusCode == 200){
      return Weather.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load weather data");
    }
  }

  Future<Intervals> getIntervals(String cityName) async {
    final response = await http.get(Uri.parse('$upcomingWeather?q=$cityName&appid=$api_key&units=imperial'));

    if(response.statusCode == 200){
      return Intervals.fromJson(jsonDecode(response.body));
    }
    else{
      throw Exception("Failed to load interval data");
    }
  }

  Future<Quote> getQuote() async {
    final response = await http.get(Uri.parse(randomQuote));

    return Quote.fromJson(jsonDecode(response.body));
  }

  // connect to Geolocator and fetch the name of the user's city through their exact location
  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }

    // grab current location
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    // convert the current location into a list of placemark objects
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    // extract the city name from the first placemark
    String? city = placemarks[0].locality;

    return city ?? "";
  }

  String getDayOfWeek(int dayIndex){
    switch (dayIndex) {
      case 0:
        return "Sunday";
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednesday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "...";
    }
  }
}