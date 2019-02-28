require("dotenv").config();

import request from "request-promise-native";

import { updateWeather } from "./ethereum";

const weather_uri = 'https://api.openweathermap.org/data/2.5/weather?q='+process.env.WEATHER_LOC+'&appid='+process.env.OPEN_WEATHER_API_KEY+'&units=metric'

const options = { uri: weather_uri, json: true };

const start = () => {
  request(options)
  .then(parseData)
  .then(updateWeather)
  .then(restart)
  .catch(error);
};

const parseData = (body) => {
  return new Promise((resolve, reject) => {
    let weatherDescription, temperature, humidity, visibility, pressure, sunrise, sunset;
    try {
      let weather = '{' +
        '"description": "' + body.weather[0].description.toString() + '",' +
        '"icon": "' + body.weather[0].icon.toString() + '",' +
        '"id": "' + body.weather[0].id.toString() + '",' +
        '"main": "' + body.weather[0].main.toString() + '",' +
        '"location": "' + body.name.toString() + '",' +
        '"country": "' + body.sys.country.toString() + '"' +
      '}';
      weatherDescription = weather;
      temperature = body.main.temp.toString();
      humidity = body.main.humidity.toString();
      visibility = body.visibility.toString();
      pressure = body.main.pressure.toString();
      sunrise = body.sys.sunrise.toString();
      sunset = (body.sys.sunset || 0).toString();
    } catch(error) {
      reject(error);
      return;
    }
    resolve({ weatherDescription, temperature, humidity, visibility, pressure, sunrise, sunset });
  });
};

const restart = () => {
  wait(process.env.WEATHER_SERVICE_TIMEOUT * 1000).then(start);
};

const wait = (milliseconds) => {
  return new Promise((resolve, reject) => setTimeout(() => resolve(), milliseconds));
};

const error = (error) => {
  console.error(error);
  restart();
};

export default start;
