import 'package:flutter/material.dart';
import 'package:my_weather/components/shimmer.dart';
import 'package:my_weather/models/location_model.dart';
import 'package:my_weather/models/weather_model.dart';
import 'package:my_weather/services/weather_service.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  //api key
  final _weatherService = WeatherService('54f089fe69281e8e31a3e433960515e8');
  Weather? _weather;

  //fetch weather
  _fetchWeather() async {
    //get current city
    MyLocation? _location = await _weatherService.getCurrentCityAndLocation();
    //get weather for city
    try {
      final weather = await _weatherService.getWeather(
          _location.latitude, _location.longitude);
      setState(() {
        _weather = weather;
      });
    }
    //any errors
    catch (e) {
      Exception(e);
    }
  }

//weather animations
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json'; //default
    final currentTime = DateTime.now();
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        if (currentTime.hour > 18 || currentTime.hour < 5) {
          return 'assets/cloudymoon.json';
        } else {
          return 'assets/cloudy.json';
        }
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        if (currentTime.hour > 18 || currentTime.hour < 5) {
          return 'assets/rainymoon.json';
        } else {
          return 'assets/rainy.json';
        }
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        if (currentTime.hour > 18 || currentTime.hour < 5) {
          return 'assets/moon.json';
        } else {
          return 'assets/sunny.json';
        }
      default:
        if (currentTime.hour > 18 || currentTime.hour < 5) {
          return 'assets/moon.json';
        } else {
          return 'assets/sunny.json';
        }
    }
  }

  Color getByTimeColor() {
    // Get the current time
    final currentTime = DateTime.now();
    // Determine the background color based on the hour
    if (currentTime.hour >= 18 || currentTime.hour < 5) {
      return Color.fromRGBO(34, 34, 34, 1); // For late hours
    } else {
      return Color.fromRGBO(246, 246, 246, 1); // Default color
    }
  }

  Color getByTimeFontColor() {
    // Get the current time
    final currentTime = DateTime.now();
    // Determine the background color based on the hour
    if (currentTime.hour >= 18 || currentTime.hour < 5) {
      return Color.fromRGBO(246, 246, 246, 1); // For late hours
    } else {
      return Color.fromRGBO(34, 34, 34, 1); // Default color
    }
  }

  //init state
  @override
  void initState() {
    super.initState();

    //fetch weather from startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getByTimeColor(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // City name and pin icon
              Container(
                margin: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.pin_drop_outlined,
                      size: 30,
                      color: getByTimeFontColor(),
                    ),
                    const SizedBox(width: 8.0),
                    _weather?.cityName == null
                        ? ShimmerBlock(
                            width: 100, height: 25) //loading animation
                        : Text(
                            _weather?.cityName ?? "Not found :()",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: getByTimeFontColor(),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Animations and temperature
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _weather?.mainCondition == null
                      ? Lottie.asset('assets/plane.json')
                      : Lottie.asset(
                          getWeatherAnimation(_weather?.mainCondition)),
                  _weather?.temperature == null
                      ? ShimmerBlock(width: 50, height: 15) //loading animation
                      : Text(
                          '${_weather?.temperature.round() ?? 0}°C',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: getByTimeFontColor(),
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 16.0),
              // Weather Condition
              Container(
                margin: EdgeInsets.only(top: 16.0),
                child: _weather?.mainCondition == null
                    ? ShimmerBlock(width: 50, height: 15) //loading animation
                    : Text(
                        _weather?.mainCondition ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: getByTimeFontColor(),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
