import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';

import 'location.dart';

const apiKey = "cb36b320fa00d0fa61f777aedd69cf21";

class WeatherDisplayData{
  Icon weatherIcon;
  AssetImage weatherImage;

  WeatherDisplayData({@required this.weatherIcon, this.weatherImage});
}


class WeatherData{
  WeatherData({@required this.locationData});

  LocationHelper locationData;
  double currentTemperature;
  int currentCondition;
  String currentAir;
  String city;

  Future<void> getCurrentTemperature() async{
    var apiUrl = Uri.parse('https://api.openweathermap.org/data/2.5/weather?lat=${locationData.latitude}&lon=${locationData.longitude}&appid=${apiKey}&units=metric');

    Response response = await get(apiUrl);

    if(response.statusCode == 200){
      String data = response.body;
      var currentWeather = jsonDecode(data);

      try{
        currentTemperature = currentWeather['main']['temp'];
        currentCondition = currentWeather['weather'][0]['id'];
        city = currentWeather['name'];
        currentAir = currentWeather['weather'][0]['main'];
      }catch(e){
        print(e);
      }

    }
    else{
      print("API den değer gelmiyor!");
    }

  }

  WeatherDisplayData getWeatherDisplayData(){
    if(currentCondition <600){
      //hava bulutlu
      return WeatherDisplayData(
          weatherIcon: Icon(
              FontAwesomeIcons.cloud,
              size: 75.0,
              color:Colors.white
          ),
          weatherImage: AssetImage('assets/bulutlu.png'));
    }
    else{
      //hava iyi
      //gece gündüz kontrolü
      var now = new DateTime.now();
      if(now.hour >=19){
        return WeatherDisplayData(
            weatherIcon: Icon(
                FontAwesomeIcons.moon,
                size: 75.0,
                color:Colors.white
            ),
            weatherImage: AssetImage('assets/gece.png'));
      }else{
        return WeatherDisplayData(
            weatherIcon: Icon(
                FontAwesomeIcons.sun,
                size: 75.0,
                color:Colors.white
            ),
            weatherImage: AssetImage('assets/gunesli.png'));

      }
    }
  }


}