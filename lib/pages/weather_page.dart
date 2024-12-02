import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../components/button.dart';
import '../models/intervals_model.dart';
import '../models/quote_model.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';
import '../theme/theme_provider.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<WeatherPage> createState() => _WeatherPage();
}

class _WeatherPage extends State<WeatherPage> {
  final _weatherService = WeatherService("e5ce5938b89a437e18456b152af8ca5f");
  Weather? _weather;
  Intervals? _intervals;
  Quote? _quote;
  List<String> days = ["...", "...", "...", "...", "...", "..."];


  _fetchWeather() async { // async allows other parts of the code to run while this function grabs the right Weather object
    // _weatherService gets the name of the user's city by using Geolocator
    String cityName = await _weatherService.getCurrentCity();

    try {
      // _weatherService gets the right Weather object by connecting to the API
      // with the desired city name and API key, fetching the JSON file that
      // corresponds with the desired city, then plugging it into Weather.fromJSON()
      final weather = await _weatherService.getWeather(cityName);
      final intervals = await _weatherService.getIntervals(cityName);
      final quote = await _weatherService.getQuote();

      for (int i = 0; i < 6; i++){
        days[i] = _weatherService.getDayOfWeek((DateTime.now().weekday+i)%7);
      }

      setState(() {
        _weather = weather;
        _intervals = intervals;
        _quote = quote;
      });
    }

    catch (e){
      print(e);
    }
  }

  String getDate(DateTime dateData){
    return "${dateData.month}/${dateData.day}/${dateData.year}";
  }

  String getWeatherAnimation(String? condition){
    if (condition == null) {
      return "assets/clear.json";
    }

    switch(condition.toLowerCase()){
      case "clouds":
        return "assets/cloudy.json";
      case "mist":
        return "assets/fog.json";
      case "smoke":
        return "assets/fog.json";
      case "haze":
        return "assets/fog.json";
      case "dust":
        return "assets/dust.json";
      case "fog":
        return "assets/fog.json";
      case "rain":
        return "assets/drizzle.json";
      case "drizzle":
        return "assets/drizzle.json";
      case "shower rain":
        return "assets/drizzle.json";
      case "thunderstorm":
        return "assets/thunderstorm.json";
      default:
        return "assets/clear.json";
    }
  }


  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context),
        home: DefaultTabController(
            length: 6,
            child: Scaffold(
                appBar: AppBar(
                  actions: [
                    MyButton(
                        color: Theme.of(context).colorScheme.secondary,
                        onTap: () {
                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        }
                    )
                  ],
                  bottom: TabBar(
                    tabs: [
                      Tab(child: Text(days[0].substring(0, 1), style: GoogleFonts.poppins())),
                      Tab(child: Text(days[1].substring(0, 1), style: GoogleFonts.poppins())),
                      Tab(child: Text(days[2].substring(0, 1), style: GoogleFonts.poppins())),
                      Tab(child: Text(days[3].substring(0, 1), style: GoogleFonts.poppins())),
                      Tab(child: Text(days[4].substring(0, 1), style: GoogleFonts.poppins())),
                      Tab(child: Text(days[5].substring(0, 1), style: GoogleFonts.poppins()))
                    ],
                  ),
                ),
                body: TabBarView(
                    children: [
                      Scaffold(
                        //backgroundColor: Theme.of(context).colorScheme.primary,
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Display city name
                              Text(_weather?.cityName ?? "Loading city...",
                                  style: GoogleFonts.poppins(textStyle: const TextStyle(fontSize: 35, fontWeight: FontWeight.w600))),

                              Text(getDate(DateTime.now()), style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 25))),
                              const SizedBox(height: 20),
                              Text(_quote?.quoteContent ?? "Loading quote...", textAlign: TextAlign.center, style: GoogleFonts.lato(textStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w400), fontStyle: FontStyle.italic),),

                              // Display corresponding animation for condition
                              SizedBox(
                                width: 225,
                                  height: 225,
                                  child: Lottie.asset(getWeatherAnimation(_weather?.condition))),

                              InfoCard(infoType: "Temperature",
                                  info: "${_weather?.temperature.round()}°F"),
                              InfoCard(infoType: "Humidity",
                                  info: "${_weather?.humidity}%"),
                              InfoCard(infoType: "Wind Speed",
                                  info: "${_weather?.windSpeed.toStringAsFixed(
                                      2)} MPH"),
                              // SizedBox(height: 20),
                              // MyButton(
                              //   color: Theme.of(context).colorScheme.secondary,
                              //   onTap: () {
                              //     Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                              //   }
                              // )
                              // ElevatedButton(
                              //     onPressed: Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                              //     child: Text("Change theme"))
                            ],
                          ),
                        ),
                      ),
                      // Display 3 hr intervals
                      displayIntervals(0, 10),
                      displayIntervals(1, 10),
                      displayIntervals(2, 10),
                      displayIntervals(3, 10),
                      displayIntervals(4, 10)
                    ])
            )
        )
    );
  }

  Scaffold displayIntervals(int inc, double space) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 60),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: Theme.of(context).colorScheme.primary,
            child:
            SizedBox(
              width: 300,
              height: 140,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(days[inc+1], style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 40, fontWeight: FontWeight.w600))),
                  Text(getDate(DateTime.now().add(Duration(days: inc+1))), style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w300))),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: Theme.of(context).colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntervalSlot(temp: "${_intervals?.temps[0+8*inc].round()}°F",
                    animation: getWeatherAnimation(
                        _intervals?.conditions[0+8*inc]),
                    time: "${_intervals?.times[0+8*inc]}"),
                SizedBox(width: space),
                IntervalSlot(temp: "${_intervals
                    ?.temps[1+8*inc].round()}°F",
                    animation: getWeatherAnimation(
                        _intervals?.conditions[1+8*inc]),
                    time: "${_intervals?.times[1+8*inc]}"),
                SizedBox(width: space),
                IntervalSlot(temp: "${_intervals
                    ?.temps[2+8*inc].round()}°F",
                    animation: getWeatherAnimation(
                        _intervals?.conditions[2+8*inc]),
                    time: "${_intervals?.times[2+8*inc]}"),
                SizedBox(width: space),
                IntervalSlot(temp: "${_intervals
                    ?.temps[3+8*inc].round()}°F",
                    animation: getWeatherAnimation(
                        _intervals?.conditions[3+8*inc]),
                    time: "${_intervals?.times[3+8*inc]}"),
              ],
                        ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            color: Theme.of(context).colorScheme.secondary,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IntervalSlot(temp: "${_intervals
                      ?.temps[4+8*inc].round()}°F",
                      animation: getWeatherAnimation(
                          _intervals?.conditions[4+8*inc]),
                      time: "${_intervals?.times[4+8*inc]}"),
                  SizedBox(width: space),
                  IntervalSlot(temp: "${_intervals
                      ?.temps[5+8*inc].round()}°F",
                      animation: getWeatherAnimation(
                          _intervals?.conditions[5+8*inc]),
                      time: "${_intervals?.times[5+8*inc]}"),
                  SizedBox(width: space),
                  IntervalSlot(temp: "${_intervals
                      ?.temps[6+8*inc].round()}°F",
                      animation: getWeatherAnimation(
                          _intervals?.conditions[6+8*inc]),
                      time: "${_intervals?.times[6+8*inc]}"),
                  SizedBox(width: space),
                  IntervalSlot(temp: "${_intervals
                      ?.temps[7+8*inc].round()}°F",
                      animation: getWeatherAnimation(
                          _intervals?.conditions[7+8*inc]),
                      time: "${_intervals?.times[7+8*inc]}"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class IntervalSlot extends StatelessWidget {
   const IntervalSlot({
     super.key,
     required this.temp,
     required this.animation,
     required this.time,
   });

   final String temp;
   final String animation;
   final String time;

   String substr(String t){
     if(t.length >= 8){
       if(t[t.length-8] == "0") {
         if(t[t.length-7] == "0") {
           return "12:00 AM";
         }
         return "${t.substring(t.length-7, t.length-3)} AM";
       }
       if(int.parse(t.substring(t.length-8, t.length-6)) > 12) {
         return "${int.parse(t.substring(t.length-8, t.length-6))-12}${t.substring(t.length-6, t.length-3)} PM";
       }
       return "${t.substring(t.length-8, t.length-3)} PM";
     }
     return "...";
   }

   @override
   Widget build(BuildContext context){
     return Column(children: [
         Card(
           color: Theme.of(context).colorScheme.surface,
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(
                 substr(time),
                 style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 16))),
           )),
         Lottie.asset(animation, width: 80, height: 80),
         Card(
           color: Theme.of(context).colorScheme.surface,
           child: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Text(
               temp,
               style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 25)),),
           )),
       ],
     );
   }
 }

class InfoCard extends StatelessWidget {
  const InfoCard({
    super.key,
    required this.infoType,
    required this.info,
  });

  final infoType;
  final info;

  IconData getIcon(String infoType){
    switch(infoType.toLowerCase()){
      case "temperature":
        return Icons.thermostat;
      case "humidity":
        return Icons.grain;
      case "wind speed":
        return Icons.air;
      default:
        return Icons.hourglass_top;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      child: SizedBox(
        width: 250,
        height: 110,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(getIcon(infoType), size: 40),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text(infoType, style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 20))),
                //SizedBox(height: 3),
                Text("$info", style: GoogleFonts.poppins(textStyle: TextStyle(fontSize: 25, fontWeight: FontWeight.w500)))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}