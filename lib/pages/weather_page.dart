import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/const/colors.dart';
import 'package:weather_app/const/dimens.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {

  final _weatherService = WeatherService('0e16dbb6931d9258715cb66e9ca666ff');
  Weather? _weather;

  _fetchWeather() async{
    String cityName = await _weatherService.getCurrentCity();

    try{
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch(e){
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition){
    if(mainCondition == null) return 'assets/sunny.json';

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
      case 'fog':
      case 'haze':
          return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
          return 'assets/partly-shower.json';
      case 'thunderstorm':
          return 'assets/storm.json';
      case 'clear':
          return 'assets/sunny.json';
      default:
          return 'assets/sunny.json';
    }
  }

  Color getWeatherBackground(String? mainCondition){
    if(mainCondition == null) return kWhiteColor;

    switch(mainCondition.toLowerCase()){
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'dust':
      case 'fog':
      case 'haze':
          return kCloudyColor;
      case 'rain':
      case 'drizzle':
      case 'shower rain':
          return kPartlyShowerColor;
      case 'thunderstorm':
          return kStormColor;
      case 'clear':
          return kSunnyColor;
      default:
          return kSunnyColor;
    }
  }

  @override
  void initState() {
    _fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getWeatherBackground(_weather?.mainCondition),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  _weather?.cityName ?? "loading city",
                  style: TextStyle(
                    color: kWhiteColor,
                    fontSize: kFontSize40x,
                  ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kSP15x),
                child: Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
              ),
              RichText(
                  text: TextSpan(
                    text: '${_weather?.temperature.round()}',
                    style: TextStyle(
                      fontSize: kFontSize20x
                    ),
                    children: const<TextSpan>[
                      TextSpan(
                        text: '°C',
                        style: TextStyle(
                          color: kSunnyColor
                        )
                      )
                    ]
                  ),

              ),
              Text(
                _weather?.mainCondition ?? '',
                style: TextStyle(
                  color: kWhiteColor,
                  fontSize: kFontSize30x,
              ),  )
            ],
          ),
        ),
    );
  }
}
