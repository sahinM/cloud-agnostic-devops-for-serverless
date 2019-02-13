#!/bin/bash

echo "$DOCKER_PW" | docker login -u "$DOCKER_USERNAME" --password-stdin
faas-cli push -f testing/weather-forecast.yml --tag staging
faas-cli deploy -f testing/weather-forecast.yml

# Some test cases
echo -n Stuttgart, DE | faas-cli invoke weather-forecast
echo -n Istanbul | faas-cli invoke weather-forecast
echo -n Heilbronn:DE | faas-cli invoke weather-forecast
