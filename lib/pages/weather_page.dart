import 'package:flutter/material.dart ';
import 'package:lottie/lottie.dart';
import 'package:weathx/models/weather_model.dart';
import 'package:weathx/services/weather_service.dart';
import 'dart:ui' as ui;

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('812f9a44a698294e3874685dcacd4e00');
  Weather? _weather;
  TextEditingController _cityController = TextEditingController();
  //fetch weather

  _fetchWeather(String? city) async {
    if (city != null) {
      //get weather for the city
      try {
        final weather = await _weatherService.getWeather(city);
        setState(() {
          _weather = weather;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  _fetchWeatherForCurrentCity() async {
    String cityName = await _weatherService.getCurrentCity();
    _fetchWeather(cityName);
  }

  //weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
    }
    return 'assets/sunny.json';
  }

  //inint state
  @override
  void initState() {
    super.initState();
    //fetch weather on startup

    _fetchWeatherForCurrentCity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/udaipur.jpg', // Replace with your image asset
              height: MediaQuery.of(context).size.height / 1.5,
              width: MediaQuery.of(context).size.width / 1,
            ),
          ),
          //Blurred Effect
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
              child: Container(
                color:
                    Colors.black.withOpacity(0.3), // Adjust opacity as needed
              ),
            ),
          ),

          // Content on top of the background
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined,size: 40.0,),
                  Text(
                    _weather?.cityName ?? "Loading city..",
                    style:  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      shadows: [
                        Shadow(
                            offset: Offset(2.0, 2.0),
                            color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  
                  // Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
                  Text(
                    '${_weather?.temperature.round()}*C',
                    style:  TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      shadows: [
                        Shadow(
                            offset: Offset(2.0, 2.0),
                            color: Colors.black.withOpacity(0.5),
                        ),
                      ],
                    ),
                  ),
                  Text(_weather?.mainCondition ?? ""),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                enableSuggestions: true,
                controller: _cityController,
                decoration: InputDecoration(
                  hintText: 'Enter The City Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              width: 8,
            ),
            ElevatedButton(
                onPressed: () {
                  _fetchWeather(_cityController.text);
                },
                child: Icon(Icons.send)),
          ],
        ),
      ),
    );
  }
}
