require("dotenv").config();

import request from "request-promise-native";

import { updateWeather } from "./ethereum";

const options = { uri: process.env.WEATHER_URL, json: true };

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
        '"main": "' + body.weather[0].main.toString() + '"' +
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
  wait(process.env.WEATHER_SERVICE_TIMEOUT).then(start);
};

const wait = (milliseconds) => {
  return new Promise((resolve, reject) => setTimeout(() => resolve(), milliseconds));
};

const error = (error) => {
  console.error(error);
  restart();
};

export default start;
