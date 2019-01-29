package com.openfaas.function;

import com.openfaas.model.IHandler;
import com.openfaas.model.IResponse;
import com.openfaas.model.IRequest;
import com.openfaas.model.Response;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

public class Handler implements com.openfaas.model.IHandler {
    private static final String API_KEY = "ed9cd70c532137e71859eb0258ebc6d2";
    private static final String API_URL = "http://api.openweathermap.org/data/2.5/weather?APPID=";
    private static final String BASE_URL = API_URL + API_KEY;

    /**
     * Text: [City] | [City],[Country] JSON: {"city": "[City]", "country":
     * "[Country]"}
     * 
     *
     */
    public IResponse Handle(IRequest req) {
        String responseBody = "";

        String body = req.getBody();
        String[] inputLocationData = body.split(",|\\s|:");

        if (inputLocationData.length < 0 || inputLocationData.length > 2) {
            responseBody = "Wrong Number of arguments! Please either enter a single value with City"
                    + "or enter a Country to it!";
        } else {
            responseBody = currentWeatherDataAsJSON(inputLocationData);
        }
        IResponse res = new Response();
        res.setBody(responseBody);
        return res;
    }

    public static String currentWeatherDataAsJSON(String[] inputLocationData) {
        StringBuilder urlStringBuilder = new StringBuilder();
        String weatherJSON = null;
        try {
            String city = null;
            String country = null;
            urlStringBuilder.append(BASE_URL).append("&q=");
            if (inputLocationData.length == 1) {
                city = inputLocationData[0].trim();
                urlStringBuilder.append(city);
            } else if (inputLocationData.length == 2) {
                city = inputLocationData[0].trim();
                country = inputLocationData[1].trim();
                urlStringBuilder.append(city).append(",").append(country);
            }
            URL requestURL = new URL(urlStringBuilder.toString());
            HttpURLConnection con = (HttpURLConnection) requestURL.openConnection();
            con.setRequestMethod("GET");
            BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream()));
            String inputLine;
            StringBuffer content = new StringBuffer();
            while ((inputLine = in.readLine()) != null) {
                content.append(inputLine);
            }
            in.close();
            con.disconnect();
            weatherJSON = content.toString();
        } catch (IOException e) {
            weatherJSON = e.getMessage();
        }
        return weatherJSON;
    }
}
